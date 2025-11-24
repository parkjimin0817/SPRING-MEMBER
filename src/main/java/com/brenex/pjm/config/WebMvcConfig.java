package com.brenex.pjm.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.web.servlet.config.annotation.*;

import java.util.List;

@Configuration
@EnableWebMvc //스프링 MVC 기능 활성화
@ComponentScan ("com.brenex.pjm") //해당 패키지 이하의 컨트롤러, 서비스, 레포지토리 등을 자동 bean에 등록
public class WebMvcConfig implements WebMvcConfigurer {
     /*
    servlet-context.xml을 대체하는 java파일
    */

    /*
    정적 자원을 컨트롤러를 거치지 않고 곧바로 브라우저에서 직접 접근할 수 있도록 매핑
     */
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/resources/**")
                .addResourceLocations("/resources/");
    }

    /*
    컨트롤러가 리턴하는 뷰 이름을 JSP경로로 연결
     */
    @Override
    public void configureViewResolvers(ViewResolverRegistry registry) {
        registry.jsp("/WEB-INF/views/", ".jsp");
    }

    /*
     JSON 변환에 사용하는 Jackson ObjectMapper에
     Java 8 날짜/시간(LocalDateTime 등)을 처리하는 모듈을 등록
     */
    @Override
    public void extendMessageConverters(List<HttpMessageConverter<?>> converters) {
        for (HttpMessageConverter<?> converter : converters) {
            if (converter instanceof MappingJackson2HttpMessageConverter) {
                MappingJackson2HttpMessageConverter jacksonConverter =
                        (MappingJackson2HttpMessageConverter) converter;

                ObjectMapper mapper = jacksonConverter.getObjectMapper();

                //LocalDateTime, LocalDate 등 지원 모듈 등록
                mapper.registerModule(new JavaTimeModule());

                //2025-11-24T10:15:32 문자열 날짜
                mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
            }
        }
    }

}
