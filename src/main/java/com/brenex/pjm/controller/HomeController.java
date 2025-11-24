package com.brenex.pjm.controller;

import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/")
public class HomeController {

    @GetMapping
    public String home(Authentication authentication) {
        //로그인 세션 체크 - 로그인 되어있으면 관리자/일반회원 각각 자신의 페이지로 갈 수 있도록
        if(authentication != null && authentication.isAuthenticated() && !(authentication instanceof AnonymousAuthenticationToken)) {
            boolean isAdmin = authentication.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
            return isAdmin ? "redirect:/admin/memberlist" : "redirect:/member/mypage";
        }
        //로그인 안되어있는 경우 메인 페이지(로그인)으로 가도록
        return "index";
    }
}
