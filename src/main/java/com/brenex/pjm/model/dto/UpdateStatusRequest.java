package com.brenex.pjm.model.dto;

import java.util.List;

public class UpdateStatusRequest {
    private List<Integer> memberList;
    private String status;
    private String reason;

    public UpdateStatusRequest() {}

    //서버 내부 (new)
    public UpdateStatusRequest(List<Integer> memberList, String status, String reason) {
        this.memberList = memberList;
        this.status = (status != null ? status.trim() : "");
        this.reason = (reason != null ? reason.trim() : "");
    }

    //getter
    public String getStatus() {
        return status;
    }

    public String getReason() {
        return reason;
    }

    public List<Integer> getMemberList() {
        return memberList;
    }

    //setter
    public void setMemberList(List<Integer> memberList) {
        this.memberList = memberList;
    }

    //외부 (json 요청)
    public void setStatus(String status) {
        this.status = (status != null ? status.trim() : "");
    }

    public void setReason(String reason) {
        this.reason = (reason != null ? reason.trim() : "");
    }
}
