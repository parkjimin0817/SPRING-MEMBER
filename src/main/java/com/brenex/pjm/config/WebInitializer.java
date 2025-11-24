package com.brenex.pjm.config;


import com.brenex.pjm.security.SecurityConfig;
import jakarta.servlet.Filter;
import org.springframework.web.filter.CharacterEncodingFilter;
import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;

public class WebInitializer extends AbstractAnnotationConfigDispatcherServletInitializer {
    /*
    web.xml을 대체하는 java파일
    */


    /*
    애플리케이션의 루트(spring container) 설정을 담당하는 클래스 지정
     */
    @Override
    protected Class<?>[] getRootConfigClasses() {
        return new Class[] { RootContext.class }; //DB, Service 등 비-웹영역
    }

    /*
    DispatcherServlet이 사용할 Spring MVC 설정 클래스를 등록
     */
    @Override
    protected Class<?>[] getServletConfigClasses() {
        return new Class[] { WebMvcConfig.class, SecurityConfig.class }; //Controller, ViewResolver 등 웹 영역
    }

    /*
    DispatcherServlet이 어떤 URL 요청을 처리할지 경로 매핑을 지정
     */
    @Override
    protected String[] getServletMappings() {
        return new String[] { "/" }; //이하 모든 요청 처리
    }

    /*
    web.xml의 <filter>역할
    모든 요청/응답의 인코딩 UTF-8로 강제
     */
    @Override
    protected Filter[] getServletFilters() {
        CharacterEncodingFilter characterEncodingFilter = new CharacterEncodingFilter();
        characterEncodingFilter.setEncoding("UTF-8");
        characterEncodingFilter.setForceEncoding(true);

        return new Filter[] { characterEncodingFilter };
    }
}
