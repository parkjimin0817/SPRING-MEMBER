package com.brenex.pjm.service;

import com.brenex.pjm.model.dto.MemberEditRequest;
import com.brenex.pjm.model.dto.MemberListResponse;
import com.brenex.pjm.model.dto.UpdateStatusRequest;
import com.brenex.pjm.model.vo.Member;

import java.util.Map;

public interface MemberService {
    //회원 가입, 리턴 값 : memberNo
    int insertMember(Member member);
    //회원 목록 조회 (페이징, 검색)
    MemberListResponse<Member> getMemberList(int page, int pageSize, String status, String role, String keyword);
    //회원 번호로 회원 정보 조회 (마이페이지)
    Member getBasicMemberInfo(int memberNo);
    //상태 변경
    Map<String, Object> updateStatus(UpdateStatusRequest request, int changedBy);
    //id로 no찾기
    int findMemberNoByMemberId(String memberId);
    //비밀번호 확인
    boolean matchPwd(int memberNo, String pwd);
    //회원 상세 정보
    Member getMemberDetail(int memberNo);
    //내 정보 수정
    void editMember(MemberEditRequest requestMember);
    //회원 권한 수정 (member, admin)
    void updateRole(int memberNo, String role);
    //회원가입 - 중복 아이디, 비밀번호 찾기 - 아이디 확인
    boolean existsById(String memberId);
    //비밀번호 찾기 - 이메일 확인
    int checkEmail(String memberId, String email);
    //비밀번호 찾기 - 비밀번호 변경
    void changePwd(int memberNo, String newPwd);
}
