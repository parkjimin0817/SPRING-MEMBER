package com.brenex.pjm.model.vo;

import java.time.LocalDateTime;

public class MemberStatusHistory {
    private int historyNo;
    private int memberNo;
    private String oldStatus;
    private String newStatus;
    private LocalDateTime changedDate;
    private String changedReason;
    private int changedBy;

    //getter
    public int getHistoryNo() {
        return historyNo;
    }

    public int getMemberNo() {
        return memberNo;
    }

    public String getOldStatus() {
        return oldStatus;
    }

    public String getNewStatus() {
        return newStatus;
    }

    public LocalDateTime getChangedDate() {
        return changedDate;
    }

    public String getChangedReason() {
        return changedReason;
    }

    public int getChangedBy() {
        return changedBy;
    }


    //setter
    public void setHistoryNo(int historyNo) {
        this.historyNo = historyNo;
    }

    public void setMemberNo(int memberNo) {
        this.memberNo = memberNo;
    }

    public void setOldStatus(String oldStatus) {
        this.oldStatus = oldStatus;
    }

    public void setNewStatus(String newStatus) {
        this.newStatus = newStatus;
    }

    public void setChangedDate(LocalDateTime changedDate) {
        this.changedDate = changedDate;
    }

    public void setChangedReason(String changedReason) {
        this.changedReason = changedReason;
    }

    public void setChangedBy(int changedBy) {
        this.changedBy = changedBy;
    }
}
