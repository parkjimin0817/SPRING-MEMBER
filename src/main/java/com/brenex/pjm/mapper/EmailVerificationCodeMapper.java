package com.brenex.pjm.mapper;

import com.brenex.pjm.model.vo.EmailVerificationCode;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface EmailVerificationCodeMapper {
    //인증 코드 정보 저장
    int insertVerificationInfo(EmailVerificationCode emailVerificationCode);
    //인증 코드 확인
    EmailVerificationCode verifyCode(@Param("memberId")String memberId, @Param("email")String email, @Param("code") String code);
    //인증 코드 used 업데이트
    int updateCodeStatus(@Param("verificationNo")int verificationNo);
    //이전 인증 코드 used 업데이트
    int disableOldCodes(@Param("memberId")String memberId, @Param("email")String email);
}
