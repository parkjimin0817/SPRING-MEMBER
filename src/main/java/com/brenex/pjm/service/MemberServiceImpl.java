package com.brenex.pjm.service;


import com.brenex.pjm.mapper.MemberMapper;
import com.brenex.pjm.mapper.MemberStatusHistoryMapper;
import com.brenex.pjm.model.dto.MemberEditRequest;
import com.brenex.pjm.model.dto.MemberListResponse;
import com.brenex.pjm.model.dto.UpdateStatusRequest;
import com.brenex.pjm.model.vo.Member;
import com.brenex.pjm.util.FormatUtil;
import com.brenex.pjm.util.MaskingUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class MemberServiceImpl implements MemberService {

    private static final Logger log = LoggerFactory.getLogger(MemberServiceImpl.class);

    private final MemberMapper memberMapper;
    private final PasswordEncoder passwordEncoder;
    private final MemberStatusHistoryMapper memberStatusHistoryMapper;

    public MemberServiceImpl(MemberMapper memberMapper, PasswordEncoder passwordEncoder, MemberStatusHistoryMapper memberStatusHistoryMapper) {
        this.memberMapper = memberMapper;
        this.passwordEncoder = passwordEncoder;
        this.memberStatusHistoryMapper = memberStatusHistoryMapper;
    }

    /*
    아이디 체크
    : 회원가입 중복 아이디 체크
    : 비밀번호 찾기 - 아이디 체크
     */
    @Override
    public boolean existsById(String memberId) {
        return memberMapper.existsById(memberId) > 0;
    }

    //회원가입
    @Transactional
    @Override
    public int insertMember(Member member) {
        //비밀번호 암호화
        member.setMemberPwd(passwordEncoder.encode(member.getMemberPwd()));
        //전화번호 '-' 제거
        member.setPhone(FormatUtil.removeHyphen(member.getPhone()));

        int result = memberMapper.insertMember(member);
        if(result != 1) {
            log.error("회원가입 실패 - memberId: {}", member.getMemberId());
            throw new RuntimeException("회원가입 중 오류가 발생했습니다.");
        }
        return member.getMemberNo();
    }

    //회원 목록 조회
    @Override
    public MemberListResponse<Member> getMemberList(int page, int pageSize, String status, String role, String keyword) {
        int offset = (page - 1) * pageSize;

        Map<String,Object> params = new HashMap<>();
        params.put("offset",offset);
        params.put("pageSize",pageSize);
        params.put("status",status);
        params.put("role",role);
        params.put("keyword",keyword);

        List<Member> list = memberMapper.selectMemberList(params);

        list.forEach(member -> {
            member.setPhone(MaskingUtil.maskPhone(member.getPhone()));
            member.setName(MaskingUtil.maskName(member.getName()));
            member.setMemberPwd(MaskingUtil.maskPwd(member.getMemberPwd()));
        });

        int totalCount = memberMapper.countMembers(params);

        return new MemberListResponse<>(list, page, pageSize,totalCount, status, role, keyword);
    }


    /*
    memberNo으로 회원 정보 불러오기
    : 마이페이지(내정보)
    : 회원가입 완료(성공)
     */
    @Override
    public Member getBasicMemberInfo(int memberNo) {
        Member member = memberMapper.selectBasicMemberInfo(memberNo);
        if (member == null) {
            log.error("회원 기본 정보 불러오는 중 회원 없음 - memberNo={}", memberNo);
            throw new RuntimeException("회원 정보를 찾지 못했습니다.");
        }
        member.setPhone(FormatUtil.formatPhone(member.getPhone()));
        return member;
    }

    /*
    상태 변경
    : 관리자가 상태변경
    : 본인 탈퇴 요청
    : createStatusHistory, updateStatus 하나라도 안되면 롤백됨
     */
    @Transactional
    @Override
    public Map<String, Object> updateStatus(UpdateStatusRequest request, int changedBy) {
        List<Integer> memberList = request.getMemberList();
        String status = request.getStatus();
        String reason = request.getReason();

        Map<String, Object> result = new HashMap<>();
        result.put("status",status);

        //상태 변경 기록
        int historyResult = memberStatusHistoryMapper.createStatusHistory(memberList, status, reason, changedBy);
        if (historyResult != memberList.size()) {
            //정상 return도하지만 롤백하고싶을때
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();

            result.put("success", false);
            log.error("변경 기록 수: {}, 변경 요청 수 :{} 불일치", historyResult, memberList.size());
            return result;
        }
        //상태 변경
        int updateResult = memberMapper.updateStatus(memberList, status);
        if (updateResult != memberList.size()) {
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();

            result.put("success", false);
            log.error("변경 완료 수: {}, 변경 요청 수 :{} 불일치", updateResult, memberList.size());
            return result;
        }

        //여기까지 왔다면 기록, 변경 성공
        result.put("success", true); 
        result.put("count", updateResult);
        result.put("status", request.getStatus());
        return result;
    }

    /*
    회원 아이디로 회원 번호 (pk 찾기)
    : 비밀번호 찾기 시 필요
     */
    @Override
    public int findMemberNoByMemberId(String memberId) {
        return memberMapper.findMemberNoByMemberId(memberId);
    }

    /*
    비밀번호 일치 확인
    : 마이페이지(비밀번호 확인),
    : 내정보수정(이전 비밀번호 비교),
    : 비밀번호 찾기(이전 비밀번호 비교)
    */
    @Override
    public boolean matchPwd(int memberNo, String pwd) {
        String encodedPwd = memberMapper.getPwdByMemberNo(memberNo);
        if (encodedPwd == null) {
            log.error("비밀번호 확인 중 회원 없음 - memberNo={}", memberNo);
            throw new RuntimeException("회원 정보를 찾을 수 없습니다.");
        }
        //일치 시 true, 불일치 시 false
        return passwordEncoder.matches(pwd, encodedPwd);
    }

    /*
    회원 상세 정보 조회
    : 회원가입 성공 - 회원 정보 보여주기
    : 회원 목록 - 회원 상세 정보 보기
     */
    @Override
    public Member getMemberDetail(int memberNo) {
        Member member =  memberMapper.selectMemberDetailWithHistory(memberNo);
        if (member == null) {
            log.error("회원 상세 조회 중 회원 없음 - memberNo={}", memberNo);
            throw new RuntimeException("해당 회원을 찾을 수 없습니다.");
        }
        member.setPhone(FormatUtil.formatPhone(member.getPhone()));
        return member;
    }

    /*
    마이페이지(내정보)
    : 내 정보 수정
    */
    @Transactional
    @Override
    public void editMember(MemberEditRequest requestMember) {
        //비밀번호 수정 유무 확인
        if (requestMember.getMemberPwd() != null && !requestMember.getMemberPwd().isBlank()) {
            //비밀번호 수정
            requestMember.setMemberPwd(passwordEncoder.encode(requestMember.getMemberPwd()));
        } else {
            //비밀번호 수정 x
            requestMember.setMemberPwd(null); // ← 쿼리에서 memberPwd update 안 됨 (아예 null값 보내기)
        }
        //전화번호 '-'제거
        requestMember.setPhone(FormatUtil.removeHyphen(requestMember.getPhone()));

        int result = memberMapper.updateMember(requestMember);
        if(result != 1){
            log.error("회원 정보 수정 중 오류 발생 - memberNo={}", requestMember.getMemberNo());
            throw new RuntimeException("회원 정보 수정에 실패했습니다.");
        }
    }

    /*
    관리자<->일반회원 권한변경
     */
    @Transactional
    @Override
    public void updateRole(int memberNo, String role) {
        int result = memberMapper.updateRole(memberNo, role);
        if (result == 0) {
            log.error("회원 권한 변경 중 오류 발생 - memberNo={}", memberNo);
            throw new RuntimeException("권한 변경을 하지 못했습니다.");
        }
    }


    /*
    아이디-이메일 회원 일치 확인
     */
    @Override
    public int checkEmail(String memberId, String email) {
        return memberMapper.checkEmail(memberId, email);
    }

    /*
    비밀번호 변경
     */
    @Transactional
    @Override
    public void changePwd(int memberNo, String newPwd) {
        String encodedPwd = passwordEncoder.encode(newPwd);
        int result = memberMapper.changePwd(memberNo, encodedPwd);
        if(result != 1) {  // 정확히 1건 수정되어야 성공
            log.error("비밀번호 찾기 - 비밀번호 변경 중 오류 - memberNo={}", memberNo);
            throw new RuntimeException("비밀번호 변경 중 오류");
        }
    }


}
