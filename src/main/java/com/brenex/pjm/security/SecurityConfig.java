package com.brenex.pjm.security;

import com.brenex.pjm.mapper.MemberMapper;
import com.brenex.pjm.security.handler.CustomAccessDeniedHandler;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

@Configuration
@EnableWebSecurity
//@EnableMethodSecurity
public class SecurityConfig {

    private final MemberMapper memberMapper;

    public SecurityConfig(MemberMapper memberMapper) {
        this.memberMapper = memberMapper;
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http, CustomAccessDeniedHandler customAccessDeniedHandler) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                    .requestMatchers(
                            "/", "/css/**", "/resources/**",
                            "/member/logout",
                            "/access-denied", "/session-expired"
                    ).permitAll() //모두 사용 가능
                    .requestMatchers("/member/login", "/member/api/checkId",
                                     "/member/register", "/member/registerResult",
                                     "/member/findPwd/**", "/member/api/findPwd/**").anonymous()
                    .requestMatchers("/admin/**").hasRole("ADMIN")
                    .requestMatchers("/member/**").hasAnyRole("MEMBER", "ADMIN")
                    .anyRequest().authenticated()
            )
            .exceptionHandling( exception ->
                    exception.accessDeniedHandler(customAccessDeniedHandler))
            .formLogin(form -> form
                    .loginPage("/")
                    .loginProcessingUrl("/member/login")
                    .usernameParameter("memberId")
                    .passwordParameter("memberPwd")
                    .successHandler(authSuccessHandler())
                    .failureHandler(authFailureHandler())
                    .permitAll()
            )
            .sessionManagement(session -> session
                    //.invalidSessionUrl("/")
                    .maximumSessions(1) //중복 로그인 방지
                    .maxSessionsPreventsLogin(false) //중복 로그인 시 로그인 가능
                    .expiredSessionStrategy( event -> {
                        HttpServletResponse response = event.getResponse();
                        response.sendRedirect("/session-expired");
                    })
            )
            .logout(l -> l
                    .logoutUrl("/member/logout")
                    .logoutSuccessUrl("/")
                    .invalidateHttpSession(true)
                    .clearAuthentication(true)
            );
        return http.build();
    }

    //인증 성공 (로그인 성공)
    @Bean
    public AuthenticationSuccessHandler authSuccessHandler() {
        return (request, response, authentication) -> {

            LoginMember loginMember = (LoginMember) authentication.getPrincipal();
            String memberRole = loginMember.getMemberRole();

            boolean isAdmin = "ADMIN".equals(memberRole);

            if(isAdmin) {
                response.sendRedirect(request.getContextPath() + "/admin/memberlist");
            } else {
                response.sendRedirect(request.getContextPath() + "/member/mypage");
            }
        };
    }

    //인증 실패 (로그인 실패)
    @Bean
    public AuthenticationFailureHandler authFailureHandler() {
        return (request, response, ex) -> {
            if (ex instanceof BadCredentialsException) {
                request.setAttribute("message", "아이디 또는 비밀번호가 올바르지 않습니다. 다시 시도해주세요.");
                request.setAttribute("memberId", request.getParameter("memberId"));
                request.getRequestDispatcher("/WEB-INF/views/index.jsp").forward(request, response);
            }

            request.setAttribute("message", ex.getMessage());
            request.setAttribute("memberId", request.getParameter("memberId"));
            request.getRequestDispatcher("/WEB-INF/views/index.jsp").forward(request, response);
        };
    }

    //비밀번호 암호화
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
