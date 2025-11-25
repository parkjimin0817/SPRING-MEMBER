package com.brenex.pjm.security;

import com.brenex.pjm.model.vo.Member;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;

import java.util.Collection;

public class LoginMember extends User {

    private final int memberNo;
    private final String memberRole;

    public LoginMember(Member member,
                       Collection<? extends GrantedAuthority> authorities) {
        super(member.getMemberId(), member.getMemberPwd(), authorities);
        this.memberNo = member.getMemberNo();
        this.memberRole = member.getMemberRole();
    }

    public int getMemberNo() { return memberNo; }
    public String getMemberRole() { return memberRole; }
}
