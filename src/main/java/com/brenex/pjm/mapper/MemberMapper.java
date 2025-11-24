package com.brenex.pjm.mapper;

import com.brenex.pjm.model.dto.MemberEditRequest;
import com.brenex.pjm.model.dto.UpdateStatusRequest;
import com.brenex.pjm.model.vo.Member;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface MemberMapper {
        //회원가입
        int insertMember(Member member);
        //아이디로 회원 찾기
        Member findByMemberId(@Param("memberId") String id);
        //회원 목록 조회
        List<Member> selectMemberList(Map<String,Object> params);
        //회원 수
        int countMembers(Map<String,Object> params);
        //회원 번호로 회원 정보 조회
        Member selectBasicMemberInfo(@Param("memberNo") int memberNo);
        //상태 변경
        int updateStatus(@Param("memberNoList") List<Integer> memberNoList, @Param("status")String status);
        //아이디로 no 찾기
        int findMemberNoByMemberId(@Param("memberId") String memberId);
        //no으로 비번 찾기
        String getPwdByMemberNo(@Param("memberNo") int memberNo);
        //회원 상제 정보 조회
        Member selectMemberDetailWithHistory(@Param("memberNo") int memberNo);
        //내 정보 수정
        int updateMember(MemberEditRequest requestMember);
        //권한 변경
        int updateRole(@Param("memberNo")int MemberNo, @Param("role")String role);
        //회원가입 - 중복 아이디 체크, 비밀번호 찾기 - 아이디 확인
        int existsById(@Param("memberId") String memberId);
        //비밀번호 찾기 - 이메일 확인
        int checkEmail(@Param("memberId")String memberId, @Param("email")String email);
        //비밀번호 찾기 - 비밀번호 변경
        int changePwd(@Param("memberNo") int memberNo, @Param("password")String password);
        //회원 정보 비식별화
        int anonymizeMember(@Param("minute") int minute);
}
