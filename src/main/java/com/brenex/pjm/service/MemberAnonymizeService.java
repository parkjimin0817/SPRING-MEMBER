package com.brenex.pjm.service;

import com.brenex.pjm.mapper.MemberMapper;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class MemberAnonymizeService {

    private final MemberMapper memberMapper;
    private static final int MINUTE = 60 * 24 * 30; //30일

    public MemberAnonymizeService(MemberMapper memberMapper) {
        this.memberMapper = memberMapper;
    }

    @Transactional
    @Scheduled(cron = "0 0 12 * * ?")
    public void anonymizeMember(){
        int anonymized = memberMapper.anonymizeMember(MINUTE);
        if(anonymized > 0){
            System.out.println("Anonymized member count: " + anonymized);
        }
    }
}
