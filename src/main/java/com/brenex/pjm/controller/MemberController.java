package com.brenex.pjm.controller;

import com.brenex.pjm.model.dto.MemberEditRequest;
import com.brenex.pjm.model.dto.UpdateStatusRequest;
import com.brenex.pjm.model.vo.Member;
import com.brenex.pjm.security.LoginMember;
import com.brenex.pjm.service.MailService;
import com.brenex.pjm.service.MemberService;
import com.brenex.pjm.service.EmailVerificationCodeService;
import com.brenex.pjm.util.RandomCodeUtil;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import org.springframework.beans.propertyeditors.StringTrimmerEditor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
@RequestMapping("/member")
public class MemberController {

    private static final Logger log = LoggerFactory.getLogger(MemberController.class);

    private final MemberService memberService;
    private final EmailVerificationCodeService emailVerificationCodeService;
    private final MailService mailService;


    public MemberController(MemberService memberService, EmailVerificationCodeService emailVerificationCodeService, MailService mailService) {
        this.memberService = memberService;
        this.emailVerificationCodeService = emailVerificationCodeService;
        this.mailService = mailService;
    }

    /*
    회원가입 페이지
     */
    @GetMapping("/register")
    public String register() {
        return "member/register";
    }

    //문자열 앞 뒤 공백 제거
    @InitBinder
    public void initBinder(WebDataBinder binder) {
        binder.registerCustomEditor(String.class, new StringTrimmerEditor(true));
    }

    /*
    회원가입
     */
    @PostMapping("/register")
    public String registerMember(@Valid @ModelAttribute("member") Member member,
                                 BindingResult result,
                                 Model model,
                                 RedirectAttributes redirectAttributes) {

        //유효성 검사
        if (result.hasErrors()) {
            model.addAttribute("message", "모든 내용을 정확히 입력해주세요.(서버 안내)");
            model.addAttribute("br", result);
            return "member/register"; //다시 회원가입 폼으로
        }

        //중복 아이디 체크
        if(memberService.existsById(member.getMemberId())) {
            result.rejectValue("memberId",null, "! 사용중인 아이디입니다.");
            model.addAttribute("br", result);
            return "member/register"; //다시 회원가입 폼으로
        }

        int savedMemberNo = memberService.insertMember(member);
        redirectAttributes.addAttribute("memberNo", savedMemberNo);
        return "redirect:/member/registerResult"; //회원가입 완료 페이지
    }

    /*
    회원가입 성공 페이지
     */
    @GetMapping("/registerResult")
    public String registerResult(@RequestParam("memberNo") int memberNo, Model model) {
        Member member = memberService.getBasicMemberInfo(memberNo);
        model.addAttribute("member", member);
        return "member/registerResult";
    }

    /*
    회원가입
    : 중복 아이디 체크
     */
    @ResponseBody
    @GetMapping("/api/checkId")
    public Map<String, Object> checkId(@RequestParam("id") String id) {
        if(id == null) { id = ""; }
        id = id.trim();

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("isDuplicate", memberService.existsById(id));
        return resultMap;
    }

    /*
    마이페이지(내정보)
    */
    @GetMapping("/mypage")
    public String getMyDetail(@AuthenticationPrincipal LoginMember loginMember, Model model) {
        int memberNo = loginMember.getMemberNo();
        Member member = memberService.getBasicMemberInfo(memberNo);
        model.addAttribute("member", member);
        return "/member/mypage";
    }

    /*
    마이페이지(내정보)
    : 비밀번호 확인
    */
    @PostMapping("/api/checkPwd")
    @ResponseBody
    public Map<String, Object> checkPwd(@AuthenticationPrincipal LoginMember loginMember, @RequestBody Map<String, String> body) {
        int memberNo = loginMember.getMemberNo();
        String password = body.get("memberPwd");

        boolean matched = memberService.matchPwd(memberNo, password); // true or false

        Map<String, Object> result = new HashMap<>();
        result.put("success", matched);
        return result;
    }

    /*
    마이페이지(내정보)
    : 내 정보 수정
    */
    @PostMapping("/edit")
    public String editMember(@AuthenticationPrincipal LoginMember loginMember,
                             @Valid @ModelAttribute MemberEditRequest requestMember,
                             BindingResult result, RedirectAttributes redirectAttributes) {
        int memberNo = loginMember.getMemberNo();
        requestMember.setMemberNo(memberNo);

        if (result.hasErrors()) {
            redirectAttributes.addFlashAttribute("message","입력 정보가 올바르지 않아 취소되었습니다. 다시 시도해주세요.");
            return "redirect:/member/mypage";
        }

        memberService.editMember(requestMember);
        redirectAttributes.addFlashAttribute("message","정보 수정이 완료되었습니다.");
        return "redirect:/member/mypage";
    }

    /*
    마이페이지(내정보)
    : 내 정보 수정 시 이전 비밀번호 체크
    */
    @PostMapping("/api/checkOldPwd")
    @ResponseBody
    public Map<String, Object> checkOldPwd(@AuthenticationPrincipal LoginMember loginMember, @RequestBody Map<String, String> body, HttpSession session) {
        int memberNo = loginMember.getMemberNo();

        String newPwd = body.get("newPwd");

        Map<String, Object> result = new HashMap<>();
        //이전 비번과 같은지 체크
        boolean same = memberService.matchPwd(memberNo, newPwd);
        result.put("success", true);
        result.put("same", same);
        return result;
    }

    /*
    마이페이지(내정보)
    : 탈퇴하기
    */
    @PostMapping("/api/withdraw")
    @ResponseBody
    public Map<String, Object> withdrawMember(@AuthenticationPrincipal LoginMember loginMember, HttpSession session) {
        int memberNo = loginMember.getMemberNo();
        //memberNo으로 리스트 만들기
        List<Integer> list = new ArrayList<>();
        list.add(memberNo);
        //request dto 만들기
        UpdateStatusRequest request = new UpdateStatusRequest(list, "WITHDRAWN", "본인 탈퇴 요청");
        //상태 변경 서비스 재사용
        Map<String, Object> result = memberService.updateStatus(request, memberNo);
        //세션 , 시큐리티 정보 제거
        if(Boolean.TRUE.equals(result.get("success"))) {
            session.invalidate();
        }
        return result;
    }

    /*
    비밀번호 찾기 페이지
    */
    @GetMapping("/findPwd")
    public String findPwdView() {
        return "member/findPwd";
    }

    /*
    비밀번호 찾기
    : 아이디 확인
    */
    @PostMapping("/api/findPwd/verifyId")
    @ResponseBody
    public Map<String, Object> findPwdVerifyId(@RequestBody Map<String, String> body) {
        Map<String, Object> result = new HashMap<>();

        String memberId = body.get("memberId");
        if (memberId == null || memberId.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "아이디를 입력해주세요.");
            return result;
        }
        memberId = memberId.trim();

        boolean exists = memberService.existsById(memberId);
        result.put("success", exists);
        if(!exists) {
            result.put("message", "입력하신 정보로 비밀번호를 재설정할 수 없습니다.");
        }
        return result;
    }

    /*
    비밀번호 찾기
    : 이메일 확인, 인증코드 전송
    */
    @PostMapping("/api/findPwd/sendCode")
    @ResponseBody
    public Map<String, Object> findPwdSendCode(@RequestBody Map<String, String> body) {
        Map<String, Object> result = new HashMap<>();

        //아이디 재확인
        String memberId = body.get("memberId");
        if (memberId == null || memberId.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "요청이 올바르지 않습니다.\n처음부터 다시 진행해주세요.");
            return result;
        }
        memberId = memberId.trim();

        //이메일 확인
        String email =  body.get("email");
        if (email == null || email.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "이메일을 입력해주세요.");
            return result;
        }
        email = email.trim();

        int count = memberService.checkEmail(memberId, email);

        if(count == 0) {
            result.put("success", false);
            result.put("message", "아이디와 이메일이 일치하지 않습니다. \n계정에 등록된 이메일을 입력해주세요.");
            return result;
        }

        try {
            //코드 생성
            String code = RandomCodeUtil.getRandomCode();
            //인증 코드 및 정보 저장
            emailVerificationCodeService.saveVerificationCode(memberId, email, code);
            //메일 전송
            mailService.sendVerificationMail(email, code);

            result.put("success", true);
        } catch (RuntimeException e) {
            log.error("인증 번호 발송 중 오류  : {}", e.getMessage());
            result.put("success", false);
            result.put("message", "인증번호 발송 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
        }

        return result;
    }

    /*
    비밀번호 찾기
    : 인증코드 확인
    */
    @PostMapping("/api/findPwd/verifyCode")
    @ResponseBody
    public Map<String, Object> verifyCode(@RequestBody Map<String, String> body, HttpSession session) {
        Map<String, Object> result = new HashMap<>();

        //아이디 재확인
        String memberId = body.get("memberId");
        if (memberId == null || memberId.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "요청이 올바르지 않습니다. \n처음부터 다시 진행해주세요.");
            return result;
        }
        memberId = memberId.trim();

        //이메일 재확인
        String email = body.get("email");
        if (email == null || email.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "요청이 올바르지 않습니다.\n처음부터 다시 진행해주세요.");
            return result;
        }
        email = email.trim();

        //인증코드 확인
        String code = body.get("code");
        if (code == null || code.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "인증코드를 정확히 입력해주세요.");
            return result;
        }
        code = code.trim();

        String status = emailVerificationCodeService.verifyCode(memberId, email, code);

        switch(status){
            case "OK":
                int memberNo = memberService.findMemberNoByMemberId(memberId);
                session.setAttribute("RESET_PWD_MEMBER", memberNo);

                result.put("success", true);
                result.put("resendAvailable", false);
                break;
            case "WRONG":
                result.put("success", false);
                result.put("message", "! 인증코드가 올바르지 않습니다.");
                result.put("resendAvailable", false);
                break;
            case "EXPIRED":
                result.put("success", false);
                result.put("message", "! 인증코드가 만료되었습니다. 다시 발급받아주세요.");
                result.put("resendAvailable", true);
                break;
            case "USED":
                result.put("success", false);
                result.put("message", "! 이미 사용된 인증코드입니다. 다시 발급받아주세요.");
                result.put("resendAvailable", true);
        }
        return result;
    }

    /*
    비밀번호 찾기
    : 이전 비밀번호 체크
    */
    @PostMapping("/api/findPwd/checkOldPwd")
    @ResponseBody
    public Map<String, Object> checkOldPwdForReset(@RequestBody Map<String, String> body, HttpSession session) {
        Map<String, Object> result = new HashMap<>();

        //세션 정보 확인
        Object sessionValue = session.getAttribute("RESET_PWD_MEMBER");
        if (sessionValue == null) {
            result.put("success", false);
            result.put("message", "요청이 올바르지 않습니다. \n처음부터 다시 진행해주세요.");
            return result;
        }
        int memberNo = (int) sessionValue;

        String newPwd = body.get("newPwd");

        //이전 비번과 같은지 체크
        boolean same = memberService.matchPwd(memberNo, newPwd);
        result.put("success", true);
        result.put("same", same);
        return result;
    }

    /*
    비밀번호 찾기
    : 비밀번호 변경
    */
    @PostMapping("/api/findPwd/changePwd")
    @ResponseBody
    public Map<String, Object> changePwd(@RequestBody Map<String, String> body, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        //세션 정보 확인
        Object sessionValue = session.getAttribute("RESET_PWD_MEMBER");
        if (sessionValue == null) {
            result.put("success", false);
            result.put("message", "비밀번호 찾기 절차가 만료되었습니다. 처음부터 다시 진행해주세요.");
            return result;
        }
        int memberNo = (int) sessionValue;

        String newPwd = body.get("newPwd");

        //비밀번호 변경
        memberService.changePwd(memberNo, newPwd);
        result.put("success", true);
        result.put("message", "비밀번호 변경이 완료되었습니다.");

        session.removeAttribute("RESET_PWD_MEMBER");
        return result;
    }
}
