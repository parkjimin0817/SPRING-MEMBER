package com.brenex.pjm.service;

import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class MailService {

    private final JavaMailSender mailSender;

    public MailService(JavaMailSender mailSender) {
        this.mailSender = mailSender;
    }

    /*
    인증코드 메일 전송
     */
    public void sendVerificationMail(String email, String randomCode) {
        SimpleMailMessage mailMessage = new SimpleMailMessage();

        mailMessage.setTo(email);
        mailMessage.setSubject("[SPRING 회원관리] 비밀번호 찾기 인증번호");
        mailMessage.setText(
                    "안녕하세요. SPRING 회원관리를 이용해주셔서 항상 감사합니다. \n\n" +
                    "요청하신 인증번호는 다음과 같습니다. \n\n" +
                    "인증번호 : " + randomCode + "\n\n" +
                    "5분 이내로 입력해주세요."
        );
        mailSender.send(mailMessage);
    }
}
