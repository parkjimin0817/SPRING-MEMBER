package com.brenex.pjm.service;

public interface EmailVerificationCodeService {

    void saveVerificationCode(String memberId, String email, String code);
    String verifyCode (String memberId, String email, String code);
}
