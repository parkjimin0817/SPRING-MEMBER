package com.brenex.pjm.controller;

import com.brenex.pjm.model.dto.MemberListResponse;
import com.brenex.pjm.model.dto.UpdateStatusRequest;
import com.brenex.pjm.model.vo.Member;
import com.brenex.pjm.security.LoginMember;
import com.brenex.pjm.service.MemberService;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@Controller
@RequestMapping("/admin")
public class AdminController {


    private final MemberService memberService;

    public AdminController(MemberService memberService) {
        this.memberService = memberService;
    }

    /*
    회원 목록 페이지
     */
    @GetMapping("/memberlist")
    public String getMemberList(@AuthenticationPrincipal LoginMember loginMember, Model model) {
        model.addAttribute("loginMemberNo", loginMember.getMemberNo());
        return "admin/memberlist";
    }

    /*
    회원 목록
    : 회원 목록 페이징, 필터링 값
     */
    @GetMapping("/api/memberlist")
    @ResponseBody
    public MemberListResponse<Member> getMemberList(@RequestParam(name = "page", defaultValue = "1") int page,
                                                    @RequestParam(name = "pageSize", defaultValue = "10") int pageSize,
                                                    @RequestParam(name = "status", defaultValue = "") String status,
                                                    @RequestParam(name = "role", defaultValue = "") String role,
                                                    @RequestParam(name = "keyword", defaultValue = "") String keyword) {
        return memberService.getMemberList(page, pageSize, status, role, keyword);
    }

    /*
    회원 목록
    : 회원 상태 변경
     */
    @PostMapping("/api/updatestatus")
    @ResponseBody
    public Map<String, Object> updateStatus(@AuthenticationPrincipal LoginMember loginMember,
                                            @RequestBody UpdateStatusRequest request) {
        int memberNo = loginMember.getMemberNo();
        return memberService.updateStatus(request, memberNo);
    }

    /*
    회원 상세 정보 조회
    : 회원 목록 - 회원 상세 정보 보기
     */
    @GetMapping("/api/memberDetail")
    @ResponseBody
    public Map<String, Object> getMemberDetail(@RequestParam(name ="memberNo") int memberNo){
        Member member =  memberService.getMemberDetail(memberNo);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("member", member);
        return result;
    }

    /*
    회원 상세 정보 조회
    : 관리자<->일반회원 권한변경
     */
    @PatchMapping("/api/updateRole/{memberNo}/role")
    @ResponseBody
    public Map<String, Object> updateRole(@PathVariable("memberNo") int memberNo,
                                          @RequestBody Map<String, String> request){
        memberService.updateRole(memberNo, request.get("role"));
        //여기까지 왔다면 권한 변경 성공 (실패는 서비스에서 잡음)
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }
}
