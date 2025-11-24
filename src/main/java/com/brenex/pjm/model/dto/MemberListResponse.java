package com.brenex.pjm.model.dto;

import java.util.List;

public class MemberListResponse<Member> {
    private List<Member> memberList;
    private  int page;
    private int pageSize;
    private int totalCount;
    private int totalPage;
    private boolean hasNext;
    private boolean hasPrevious;
    private String status;
    private String role;
    private String keyword;

    public MemberListResponse(List<Member> memberList, int page, int pageSize, int totalCount, String status, String role, String keyword) {
        this.memberList = memberList;
        this.page = page;
        this.pageSize = pageSize;
        this.totalCount = totalCount;
        this.totalPage = (int)Math.ceil((double)totalCount / pageSize);
        this.hasNext = page < totalPage;
        this.hasPrevious = page > 1;
        this.status = status;
        this.role = role;
        this.keyword = keyword;
    }

    //getter
    public List<Member> getMemberList() {
        return memberList;
    }

    public int getPage() {
        return page;
    }

    public int getPageSize() {
        return pageSize;
    }

    public int getTotalPage() {
        return totalPage;
    }

    public int getTotalCount() {
        return totalCount;
    }

    public boolean isHasNext() {
        return hasNext;
    }

    public boolean isHasPrevious() {
        return hasPrevious;
    }

    public String getStatus() {
        return status;
    }

    public String getKeyword() {
        return keyword;
    }

    public String getRole() {
        return role;
    }

    //setter

    public void setPage(int page) {
        this.page = page;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }

    public void setMemberList(List<Member> memberList) {
        this.memberList = memberList;
    }

    public void setTotalCount(int totalCount) {
        this.totalCount = totalCount;
    }

    public void setTotalPage(int totalPage) {
        this.totalPage = totalPage;
    }

    public void setHasNext(boolean hasNext) {
        this.hasNext = hasNext;
    }

    public void setHasPrevious(boolean hasPrevious) {
        this.hasPrevious = hasPrevious;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }

    public void setRole(String role) {
        this.role = role;
    }
}
