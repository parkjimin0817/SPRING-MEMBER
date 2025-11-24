package com.brenex.pjm.model.vo;

import jakarta.validation.constraints.*;

import java.time.LocalDateTime;

public class Member {
    private int memberNo;

    @NotBlank(message = "! 아이디를 입력해주세요.")
    @Pattern(regexp = "^(?=.*[A-Za-z])[A-Za-z0-9]{5,20}$",
            message = "! 아이디는 영어 대소문자, 숫자를 포함한 5~20자로 입력해주세요.")
    private String memberId;

    @NotBlank(message = "! 비밀번호를 입력해주세요.")
    @Pattern(regexp = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&*(),.?\":{}|<>])[A-Za-z\\d!@#$%^&*(),.?\":{}|<>]{8,20}$",
            message = "! 비밀번호는 영어, 숫자, 특수문자를 포함한 8~20자로 입력해주세요.")
    private String memberPwd;

    @NotBlank(message = "! 이름을 입력해주세요.")
    @Pattern(regexp = "^[가-힣]{1,10}$", message = "! 이름은 한글 10자 이내로 입력해주세요.")
    private String name;

    private String gender;

    @Min(value = 20, message = "! 나이는 20세 ~ 99세에서 선택해주세요.")
    @Max(value = 99, message = "! 나이는 20세 ~ 99세에서 선택해주세요.")
    private int age;

    @NotBlank(message = "! 우편번호를 입력해주세요.")
    @Size(min = 5, max = 5, message = "! 정확한 우편번호를 입력해주세요.")
    private String zipCode;
    @NotBlank(message = "! 주소를 입력해주세요.")
    private String addressBase;
    @Size(max = 40, message = "! 상세주소는 40자 이내로 입력해주세요.")
    private String addressDetail;

    @NotBlank(message = "! 전화번호를 입력해주세요.")
    @Pattern(regexp = "^01[0-9]-?\\d{3,4}-?\\d{4}$", message = "! 올바른 전화번호를 입력해주세요.")
    private String phone;

    @NotBlank(message = "! 이메일을 입력해주세요.")
    @Size(min = 1, max = 20, message = "! 이메일은 20자 이내로 입력해주세요.")
    @Email(message = "! 올바른 이메일 형식을 입력해주세요.")
    private String email;

    private String memberStatus;
    private String memberRole;
    private LocalDateTime createdDate;
    private LocalDateTime modifyDate;

    private String anonymizedYN;
    private LocalDateTime anonymizedDate;

    private String changedReason;
    private LocalDateTime changedDate;


    //getter
    public int getMemberNo() {
        return memberNo;
    }

    public String getMemberId() {
        return memberId;
    }

    public String getMemberPwd() {
        return memberPwd;
    }

    public String getName() {
        return name;
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
        return (addressDetail != null ? addressDetail : "");
    }

    public String getPhone() {
        return phone;
    }

    public String getEmail() {
        return email;
    }

    public String getMemberStatus() {
        return memberStatus;
    }

    public String getMemberRole() {
        return memberRole;
    }

    public LocalDateTime getCreatedDate() {
        return createdDate;
    }

    public LocalDateTime getModifyDate() {
        return modifyDate;
    }

    public String getChangedReason() {
        return changedReason;
    }

    public LocalDateTime getChangedDate() {
        return changedDate;
    }

    //setter
    public void setMemberNo(int memberNo) {
        this.memberNo = memberNo;
    }

    public void setMemberId(String memberId) {
        this.memberId = memberId;
    }

    public void setMemberPwd(String memberPwd) {
        this.memberPwd = memberPwd;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public void setAddressBase(String addressBase) {
        this.addressBase = addressBase;
    }

    public void setZipCode(String zipCode) {
        this.zipCode = zipCode;
    }

    public void setAddressDetail(String addressDetail) {
        this.addressDetail = (addressDetail != null ? addressDetail : "");
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public void setMemberStatus(String memberStatus) {
        this.memberStatus = memberStatus;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setMemberRole(String memberRole) {
        this.memberRole = memberRole;
    }

    public void setCreatedDate(LocalDateTime createdDate) {
        this.createdDate = createdDate;
    }

    public void setModifyDate(LocalDateTime modifyDate) {
        this.modifyDate = modifyDate;
    }

    public void setChangedReason(String changedReason) {
        this.changedReason = changedReason;
    }

    public void setChangedDate(LocalDateTime changedDate) {
        this.changedDate = changedDate;
    }

    @Override
    public String toString() {
        return "Member{" +
                "memberNo=" + memberNo +
                ", memberId='" + memberId + '\'' +
                ", memberPwd='" + memberPwd + '\'' +
                ", name='" + name + '\'' +
                ", gender='" + gender + '\'' +
                ", age=" + age +
                ", zipCode='" + zipCode + '\'' +
                ", addressBase='" + addressBase + '\'' +
                ", addressDetail='" + addressDetail + '\'' +
                ", phone='" + phone + '\'' +
                ", email='" + email + '\'' +
                ", memberStatus='" + memberStatus + '\'' +
                ", memberRole='" + memberRole + '\'' +
                ", createdDate=" + createdDate +
                ", modifyDate=" + modifyDate +
                ", changedReason='" + changedReason + '\'' +
                ", changedDate=" + changedDate +
                '}';
    }

    public String getAnonymizedYN() {
        return anonymizedYN;
    }

    public void setAnonymizedYN(String anonymizedYN) {
        this.anonymizedYN = anonymizedYN;
    }

    public LocalDateTime getAnonymizedDate() {
        return anonymizedDate;
    }

    public void setAnonymizedDate(LocalDateTime anonymizedDate) {
        this.anonymizedDate = anonymizedDate;
    }
}
