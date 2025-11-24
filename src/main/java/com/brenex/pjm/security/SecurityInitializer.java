package com.brenex.pjm.security;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import org.springframework.web.WebApplicationInitializer;
import org.springframework.web.filter.DelegatingFilterProxy;
import org.springframework.web.servlet.FrameworkServlet;

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

