package com.brenex.pjm.service;

import com.brenex.pjm.mapper.EmailVerificationCodeMapper;
import com.brenex.pjm.model.vo.EmailVerificationCode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
public class EmailVerificationCodeServiceImpl implements EmailVerificationCodeService {

    private static final Logger log = LoggerFactory.getLogger(EmailVerificationCodeServiceImpl.class);

    private final EmailVerificationCodeMapper emailVerificationCodeMapper;

    public EmailVerificationCodeServiceImpl(EmailVerificationCodeMapper emailVerificationCodeMapper) {
        this.emailVerificationCodeMapper = emailVerificationCodeMapper;
    }

    /*
    인증코드 정보 저장
     */
    @Transactional
    @Override
    public void saveVerificationCode(String memberId, String email, String code) {

        //기존에 전송된 코드들 USED='Y' 처리
        int disabled = emailVerificationCodeMapper.disableOldCodes(memberId, email);
        log.debug("기존 인증코드 {}건 무효화 - memberId={}, email={}", disabled, memberId, email);

        LocalDateTime now = LocalDateTime.now();
        LocalDateTime expiredTime = now.plusMinutes(5);

        EmailVerificationCode emailVerificationCode = new EmailVerificationCode();
        emailVerificationCode.setMemberId(memberId);
        emailVerificationCode.setEmail(email);
        emailVerificationCode.setCode(code);
        emailVerificationCode.setExpiredTime(expiredTime);
        emailVerificationCode.setCreatedTime(now);

        int result = emailVerificationCodeMapper.insertVerificationInfo(emailVerificationCode);

        if(result == 0) {
            log.error("인증코드 정보 저장 실패 - memberId={}, email={}, code={}", memberId, email, code);
            throw new RuntimeException("인증코드 정보 저장 실패: memberId=" + memberId + ", email=" + email);
        }
    }

    /*
    인증코드 확인
     */
    @Transactional
    @Override
    public String verifyCode(String memberId, String email, String code) {
        EmailVerificationCode emailVerificationCode=  emailVerificationCodeMapper.verifyCode(memberId, email, code);
        //인증 코드 틀린 경우 (정상적 실패)
        if (emailVerificationCode == null) {return "WRONG";}
        //만료시간 지난 경우 (정상적 실패)
        if(emailVerificationCode.getExpiredTime().isBefore(LocalDateTime.now())){ return "EXPIRED"; }
        //이미 사용된 코드일 경우 (정상적 실패)
        if(emailVerificationCode.getUsed().equals("Y")){ return "USED"; }


        int updated = emailVerificationCodeMapper.updateCodeStatus(emailVerificationCode.getVerificationNo());

        //인증코드 정보 업데이트 실패 (비정상적 실패)
        if(updated != 1) {
            log.error("인증코드 상태 변경 실패 - memberId={}, email={}, code={}", memberId, email, code);
            throw new RuntimeException("인증코드 상태 변경 실패 : memberId=" + memberId + ", email=" + email);
        }

        //두 경우에 걸리지 않았을 경우 true
        return "OK";
    }
}
