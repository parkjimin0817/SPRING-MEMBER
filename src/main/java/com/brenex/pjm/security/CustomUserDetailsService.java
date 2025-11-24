package com.brenex.pjm.security;

import com.brenex.pjm.mapper.MemberMapper;
import com.brenex.pjm.model.vo.Member;
import com.brenex.pjm.util.FormatUtil;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    private final MemberMapper memberMapper;

    public CustomUserDetailsService(MemberMapper memberMapper) {
        this.memberMapper = memberMapper;
    }

    @Override
    public UserDetails loadUserByUsername(String memberId) {
        Member member = memberMapper.findByMemberId(memberId);

        if (member == null) { throw new BadCredentialsException("아이디 또는 비밀번호가 올바르지 않습니다.");}

        //상태 사유, 날짜
        String statusReason = member.getChangedReason();
        String formattedDate = FormatUtil.formatDate(member.getChangedDate());

        if(statusReason == null || statusReason.isBlank()){
            statusReason = "-";
        }

        switch (member.getMemberStatus()) {
            case "APPROVED" : break;
            case "PENDING" : break;
            case "REJECTED": throw new DisabledException("승인 거절된 계정입니다.\\n사유 : " + statusReason + " (" + formattedDate + ")");
            case "DELETED": throw new DisabledException("삭제된 계정입니다.\\n사유 : " + statusReason + " (" + formattedDate + ")");
            case "WITHDRAWN": throw new DisabledException("탈퇴된 계정입니다.\\n사유 : " + statusReason + " (" + formattedDate + ")");
            default: throw new DisabledException("알 수 없는 상태입니다.");
        }

        List<GrantedAuthority> authorities =
                List.of(new SimpleGrantedAuthority("ROLE_" + member.getMemberRole()));

        return new LoginMember(member, authorities);
    }
}
