package com.brenex.pjm.model.dto;

import jakarta.validation.constraints.*;

public class MemberEditRequest {

    private int memberNo;

    @Pattern(regexp = "^$|^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&*(),.?\":{}|<>])[A-Za-z\\d!@#$%^&*(),.?\":{}|<>]{8,20}$")
    private String memberPwd;

    private String gender;

    @Min(value = 20)
    @Max(value = 99)
    private int age;

    @NotBlank
    @Size(min = 5, max = 5)
    private String zipCode;
    @NotBlank
    private String addressBase;
    @Size(max = 40)
    private String addressDetail;

    @NotBlank
    @Pattern(regexp = "^01[0-9]-?\\d{3,4}-?\\d{4}$")
    private String phone;

    @NotBlank
    @Size(min = 1, max = 20)
    @Email
    private String email;


    //getter
    public int getMemberNo() {
        return memberNo;
    }

    public String getMemberPwd() {
        return memberPwd;
    }

    public String getGender() {
        return gender;
    }

    public int getAge() {
        return age;
    }

    public String getZipCode() {
        return zipCode;
    }

    public String getAddressBase() {
        return addressBase;
    }

    public String getAddressDetail() {
        return addressDetail;
    }

    public String getPhone() {
        return phone;
    }

    public String getEmail() {
        return email;
    }

    //setter
    public void setMemberNo(int memberNo) {
        this.memberNo = memberNo;
    }

    public void setMemberPwd(String memberPwd) {
        this.memberPwd = memberPwd;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public void setAddressBase(String addressBase) {
        this.addressBase = addressBase;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public void setZipCode(String zipCode) {
        this.zipCode = zipCode;
    }

    public void setAddressDetail(String addressDetail) {
        this.addressDetail = addressDetail;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}
