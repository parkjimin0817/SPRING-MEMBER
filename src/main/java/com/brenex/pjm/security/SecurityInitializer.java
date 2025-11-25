package com.brenex.pjm.security;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import org.springframework.web.WebApplicationInitializer;
import org.springframework.web.filter.DelegatingFilterProxy;
import org.springframework.web.servlet.FrameworkServlet;

/*
DispatcherServlet 이전에 Spring Security 필터 체인을 동작시키도록 등록하는 부트스트랩 클래스
 */
public class SecurityInitializer implements WebApplicationInitializer {

    @Override
    public void onStartup(ServletContext servletContext) throws ServletException {
        String dispatcherAttr = FrameworkServlet.SERVLET_CONTEXT_PREFIX + "dispatcher";
        DelegatingFilterProxy proxy = new DelegatingFilterProxy("springSecurityFilterChain");
        proxy.setContextAttribute(dispatcherAttr);
        servletContext.addFilter("springSecurityFilterChain", proxy)
                .addMappingForUrlPatterns(null, false, "/*");
    }

}

