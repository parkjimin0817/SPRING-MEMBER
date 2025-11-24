package com.brenex.pjm.controller;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ErrorPageController {
    /*
    다른 기기에서 로그인 시, 세션 만료 시
     */
    @GetMapping("/session-expired")
    public String sessionExpiredPage(HttpServletRequest request) {
        request.setAttribute("message", "로그인 유지 시간이 끝났습니다. \\n다시 로그인 후 이용해주세요.");
        request.setAttribute("path", "/");
        return "common/alert";
    }
}
