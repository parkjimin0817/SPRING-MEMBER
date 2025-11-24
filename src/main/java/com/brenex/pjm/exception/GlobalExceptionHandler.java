package com.brenex.pjm.exception;

import jakarta.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.NoHandlerFoundException;

import java.util.HashMap;
import java.util.Map;

@ControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger log =  LoggerFactory.getLogger(GlobalExceptionHandler.class);

    //api 요청 판단 메서드
    private boolean isApiRequest (HttpServletRequest request) {
        String uri = request.getRequestURI();
        return "XMLHttpRequest".equals(request.getHeader("X-Requested-With")) || uri.contains("/api");
    }

    //기본 예외 핸들러
    @ExceptionHandler(Exception.class)
    public Object handleException(Exception ex, HttpServletRequest request) {

        String uri = request.getRequestURI();
        log.error("Unhandled exception at {} : {}", uri, ex.getMessage(), ex);

        //api
        if(isApiRequest(request)) {
            Map<String, Object> body = new HashMap<>();
            body.put("error", true);
            body.put("message", "api 요청 처리 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요. \n\n동일한 문제가 계속되면 관리자에게 문의해주세요. \n관리자 문의 : 1515-1515");
            return ResponseEntity.ok(body);
        }

        //요청 보냈던 페이지
        String referer = request.getHeader("Referer");
        String gotoPath = (referer != null && !referer.isBlank()) ? referer : request.getContextPath() + "/";
        request.setAttribute("message", "요청 처리 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요. \\n\\n동일한 문제가 계속되면 관리자에게 문의해주세요. \\n관리자 문의 : 1515-1515");
        request.setAttribute("path", gotoPath);

        return "common/alert";
    }

    //404 핸들러
    @ExceptionHandler(NoHandlerFoundException.class)
    public Object handleNoHandlerFoundException(Exception ex, HttpServletRequest request) {

        String uri = request.getRequestURI();
        log.error("404 Not found at {} : {}", uri, ex.getMessage(), ex);

        //api
        if (isApiRequest(request)) {
            Map<String, Object> body = new HashMap<>();
            body.put("error", true);
            body.put("message", "요청하신 주소를 찾을 수 없습니다.");
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(body);
        }

        //화면 요청이면 404 전용 JSP로
        request.setAttribute("requestedPath", uri);
        return "common/404";
    }
}
