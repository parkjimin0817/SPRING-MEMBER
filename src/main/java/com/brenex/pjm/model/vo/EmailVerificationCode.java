package com.brenex.pjm.model.vo;

import java.time.LocalDateTime;

public class EmailVerificationCode {
    private int verificationNo;
    private String memberId;
    private String email;
    private String code;
    private LocalDateTime expiredTime;
    private LocalDateTime createdTime;
    private String used;

    //getter, setter
    public int getVerificationNo() {
        return verificationNo;
    }

    public void setVerificationNo(int verificationNo) {
        this.verificationNo = verificationNo;
    }

    public String getMemberId() {
        return memberId;
    }

    public void setMemberId(String memberId) {
        this.memberId = memberId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public LocalDateTime getExpiredTime() {
        return expiredTime;
    }

    public void setExpiredTime(LocalDateTime expiredTime) {
        this.expiredTime = expiredTime;
    }

    public LocalDateTime getCreatedTime() {
        return createdTime;
    }

    public void setCreatedTime(LocalDateTime createdTime) {
        this.createdTime = createdTime;
    }

    public String getUsed() {
        return used;
    }

    public void setUsed(String used) {
        this.used = used;
    }
}
