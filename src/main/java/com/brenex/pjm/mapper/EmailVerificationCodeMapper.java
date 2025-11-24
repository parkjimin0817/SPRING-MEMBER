package com.brenex.pjm.mapper;

import com.brenex.pjm.model.vo.EmailVerificationCode;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface EmailVerificationCodeMapper {
    int insertVerificationInfo(EmailVerificationCode emailVerificationCode);
    EmailVerificationCode verifyCode(@Param("memberId")String memberId, @Param("email")String email, @Param("code") String code);
    int updateCodeStatus(@Param("verificationNo")int verificationNo);
    int disableOldCodes(@Param("memberId")String memberId, @Param("email")String email);
}
