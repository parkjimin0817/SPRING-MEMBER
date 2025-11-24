<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>

    <meta charset="UTF-8">
    <title>내 정보</title>

    <style>
        /* 마이페이지 전체 컨테이너 */
        #mypage-container {
            max-width: 500px;
            margin: 40px auto;
            padding: 24px 28px;
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
        }

        /* 제목 */
        #mypage-container h2 {
            font-size: 22px;
            font-weight: 600;
            margin-bottom: 20px;
            color: #333;
            border-bottom: 1px solid #e5e5e5;
            padding-bottom: 8px;
        }

        /* 내 정보 테이블 */
        #mypage-container table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }

        /* 각 셀 공통 */
        #mypage-container table th,
        #mypage-container table td {
            padding: 10px 12px;
            border-bottom: 1px solid #e5e5e5;
            vertical-align: top;
        }

        /* 왼쪽 라벨 영역 */
        #mypage-container table th {
            width: 25%;
            background-color: #f8f9fa;
            font-weight: 600;
            text-align: left;
            color: #333;
        }

        /* 오른쪽 값 영역 */
        #mypage-container table td {
            text-align: left;
            color: #555;
            word-break: break-word;
        }

        /* 마지막 줄은 보더 없애기 (옵션) */
        #mypage-container table tr:last-child th,
        #mypage-container table tr:last-child td {
            border-bottom: none;
        }

        .btn-area {
            display: flex;
            flex-direction: column;
            align-items: center;
            margin-top: 30px;
            gap: 12px; /* 버튼 간 간격 */
        }

        #edit-btn {
            width: 50%;
            height: 42px;
            background-color: #00ac00;
            border: none;
            border-radius: 6px;
            color: white;
            font-size: 15px;
            cursor: pointer;
            transition: background-color 0.2s ease;
        }

        #edit-btn:hover {
            background-color: #008800;
        }

        #verifyPwdModal .modal-body {
            text-align: center;
        }

        #current-pwd-check-msg{
            margin: 0 auto;
            width: 220px;
            text-align: left;
            min-height: 16px;
            font-size: 12px;
            line-height: 1.3;
            color: red;
            transition: color 0.2s, opacity 0.2s;
        }

        #withdrawBtn {
            text-align: center;
            margin-top: 5px;
            font-size: 12px;
            color: black;
            text-decoration: none;
            cursor: pointer;
            margin-left: 370px;
        }

        #withdrawBtn:hover {
            text-decoration: underline;
        }


        /* ===== 내 정보 수정 모달 레이아웃 ===== */
        #member-edit-form {
            width: 300px;              /* 회원가입/로그인과 동일 폭 */
            margin: 0 auto;
            display: flex;
            flex-direction: column;
            row-gap: 10px;
        }

        /* 각 줄(라벨 + 인풋) */
        .edit-input-group {
            width: 300px;
            min-height: 40px;
            display: flex;
            align-items: center;
            gap: 8px;
            border: 1px solid #ccc;
            padding: 0 0 0 10px;
            background: #fff;
            border-radius: 5px;
            box-sizing: border-box;
        }

        /* 왼쪽 라벨 */
        .edit-label {
            font-size: 13px;
            color: #555;
            white-space: nowrap;
        }

        /* 실제 입력 요소 공통 */
        .edit-input {
            flex: 1;
            min-width: 0;
            border: none;
            outline: none;
            background: transparent;
            height: 36px;
            font-size: 14px;
        }

        /* small 버튼 (우편번호/검색 등) */
        .edit-btn-small {
            font-size: 12px;
            padding: 6px 10px;
            background-color: #00ac00;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            white-space: nowrap;
            height: 38px;
        }

        .edit-btn-small:hover {
            background-color: #008800;
        }

        /* 메시지 영역 (비밀번호 불일치 등) */
        #editModal .msgBox {
            width: 300px;
            min-height: 16px;
            margin: 0;
            font-size: 11px;
            line-height: 1.3;
            color: red;
            transition: color 0.2s, opacity 0.2s;
        }

        /*비밀번호 변경*/
        .toggle-pwd-area {
            display: inline-block;
            padding: 4px 10px;
            font-size: 13px;
            border: 1px solid #888;      /* 아웃라인 */
            border-radius: 6px;
            background-color: #9e9e9e;
            color: black;
            cursor: pointer;
            transition: all 0.15s ease-in-out;
        }

        .toggle-pwd-area:hover {
            background-color: #fbfafa;
            border-color: #555;
        }

        .toggle-pwd-area:active {
            background-color: #e8e8e8;
        }

        #pwd-area {
            display: flex;
            flex-direction: column;
            gap: 8px;  /* 내부 요소 간 간격 */
        }
    </style>

    <%-- 부트스트랩 js--%>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <%--다음 주소 api--%>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <%-- jquery --%>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <script>
        //비밀번호 확인
        async function checkCurrentPwd(){
            const input = document.getElementById('member-current-pwd')
            const pwd = input.value.trim();
            const msgBox = document.getElementById('current-pwd-check-msg');

            if(!pwd){
                msgBox.textContent = "! 비밀번호를 입력해주세요."
                msgBox.style.color = "red";
                input.focus();
                return;
            } else {
                msgBox.textContent = "";
            }

            try {
                const response = await fetch ('/member/api/checkPwd', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json; charset=UTF-8'},
                    body: JSON.stringify({memberPwd: pwd})
                });

                const result = await response.json();

                //예외 처리기
                if (result.error) {
                    alert(result.message);
                    return;
                }

                if(result.success){
                    const pwdModalEl = document.getElementById('verifyPwdModal');
                    const editModalEl = document.getElementById('editModal');

                    const pwdModal  = bootstrap.Modal.getOrCreateInstance(pwdModalEl);
                    const editModal = bootstrap.Modal.getOrCreateInstance(editModalEl);
                    pwdModal.hide();

                    if(btnValue === 'edit'){
                        setTimeout(() => editModal.show(), 150);
                    } else if (btnValue === 'withdraw') {
                        const confirmed = confirm('정말 탈퇴하시겠습니까?');
                        if(!confirmed) return;
                        await withdrawMember();
                    }

                } else {
                    msgBox.textContent = "! 비밀번호가 일치하지 않습니다.";
                    msgBox.style.color = "red";
                    input.focus();
                    input.select();
                }
            } catch (err) {
                console.error(err);
                alert('네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
            }
        }

        function checkInput() {
            const input  = document.getElementById('member-current-pwd');
            const pwd = input.value.trim();
            const msgBox = document.getElementById('current-pwd-check-msg');
            // 입력 중엔 경고만 지움 (서버 요청 X)
            if (pwd) {
                msgBox.textContent = '';
                msgBox.style.color = '';
            }
        }

        document.addEventListener("DOMContentLoaded", () => {
            const pwdModalEl = document.getElementById('verifyPwdModal');
            const input = document.getElementById('member-current-pwd');
            const msgBox = document.getElementById('current-pwd-check-msg');

            pwdModalEl.addEventListener('hidden.bs.modal', () => {
                input.value = "";
                msgBox.textContent = "";
                msgBox.style.color = "";
            });
        });

        //버튼
        let btnValue;
        function setValue(value){
            btnValue = value;
        }

        //서버에 탈퇴 요청 보내기
        async function withdrawMember() {
            try {
                const response = await fetch("/member/api/withdraw", {
                    method: 'POST',
                    headers: { "Content-Type": "application/json" },
                });

                const result = await response.json();

                //예외 처리기
                if (result.error) {
                    alert(result.message);
                    return;
                }

                if(result.success){
                    alert('탈퇴가 완료되었습니다.');
                    window.location.href = '${pageContext.request.contextPath}/'
                } else {
                    alert('탈퇴에 실패했습니다. 다시 시도해주세요.');
                }

            } catch (err) {
                console.error(err);
                alert('네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
            }
        }

        //---------------정보 수정-------------------

        //비밀번호 형식 검사
        async function checkPwd(){
            const memberPwd = document.getElementById('edit-password').value.trim();
            const checkPwd = document.getElementById('edit-password-check').value.trim();
            const msgBox = document.getElementById('pwd-check-msg');

            //비밀번호 수정 x
            if (!memberPwd && !checkPwd) {
                msgBox.style.display = "none";
                msgBox.textContent = "";
                return true;
            };

            //비밀번호 형식 검사 - 영어 대소문자 & 숫자 & 특수문자 & 20자내
            const pwdRule =  /^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{8,20}$/; //영어 대소문자, 숫자, 특수문자 8-20자
            if(!pwdRule.test(memberPwd)){
                msgBox.style.display = "block"
                msgBox.textContent = "! 비밀번호는 영어, 숫자, 특수문자를 포함한 8~20자로 입력해주세요."
                msgBox.style.color = "red";
                return false;
            } else {
                msgBox.style.display = "none"
                msgBox.textContent = ""
                msgBox.style.color = "";
            }

            try {
                const response = await fetch("/member/api/checkOldPwd", {
                    method: "POST",
                    headers: {"Content-Type" : "application/json"},
                    body: JSON.stringify({newPwd : memberPwd})
                });

                const result = await response.json();

                if(result.error){
                    alert(result.message);
                    return false;
                }

                if(result.success) {
                    if(result.same){
                        msgBox.style.display = "block";
                        msgBox.style.color = "red";
                        msgBox.textContent = "! 이전 비밀번호와 동일한 비밀번호는 사용할 수 없습니다."
                        return false;
                    } else {
                        msgBox.style.display= "none";
                        msgBox.textContent = "";
                        msgBox.style.color = "";
                        return true;
                    }
                }
            } catch (error) {
                console.error('에러' + error);
                alert('네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
                return false;
            }
        }

        function checkCheckPwd(){
            const memberPwd = document.getElementById('edit-password').value.trim();
            const checkPwd = document.getElementById('edit-password-check').value.trim();
            const msgBox = document.getElementById('checkpwd-check-msg');

            //비밀번호 수정 x
            if (!memberPwd && !checkPwd) {
                msgBox.style.display = "none";
                msgBox.textContent = "";
                return true;
            }

            //비밀번호 일치 확인
            if(memberPwd !== checkPwd){
                msgBox.style.display = "block"
                msgBox.textContent = "! 비밀번호가 일치하지 않습니다. 다시 입력해주세요"
                msgBox.style.color = "red";
                return false;
            } else {
                msgBox.style.display = "none"
                msgBox.textContent = ""
                msgBox.style.color = "";
                return true;
            }
        }

        //다음 주소 검색
        function searchAddress() {
            new daum.Postcode({
                oncomplete: function (data) {
                    document.getElementById('edit-zipCode').value = data.zonecode;
                    document.getElementById('edit-addressBase').value = data.address;
                    document.getElementById('edit-addressDetail').value = '';
                    document.getElementById('edit-addressDetail').focus();
                }
            }).open();
        }

        //주소 형식 검사
        function checkAddress(){
            const zipCode = document.getElementById("edit-zipCode").value.trim();
            const addressBase = document.getElementById("edit-addressBase").value.trim();
            const addressDetail = document.getElementById("edit-addressDetail").value.trim();
            const msgBox = document.getElementById("address-check-msg");

            if( !zipCode || !addressBase ){
                msgBox.style.display = "block"
                msgBox.textContent = "! 주소를 검색하여 선택해주세요."
                msgBox.style.color = "red";
                return false;
            }

            const len = addressDetail.length;

            if( len > 40 ) {
                msgBox.style.display = "block"
                msgBox.textContent = "! 상세주소는 40자 이내로 입력해주세요."
                msgBox.style.color = "red";
                return false;
            }

            msgBox.style.display = "none"
            msgBox.textContent = "";
            msgBox.style.color = "";
            return true;

        }


        //전화번호 형식 검사
        function checkPhone(){
            const phoneInput = document.getElementById("edit-phone");
            const phoneNumber = phoneInput.value.trim();
            const msgBox = document.getElementById("phone-check-msg");

            const phoneRule = /^01[0-9]-?\d{3,4}-?\d{4}$/;
            const len = phoneNumber.length;

            if(!phoneRule.test(phoneNumber)){
                msgBox.style.display = "block"
                msgBox.textContent = "! 올바른 전화번호를 입력해주세요."
                msgBox.style.color = "red";
                return false;
            } else {
                msgBox.style.display = "none"
                msgBox.textContent = ""
                msgBox.style.color = "";

                if(len>=10){
                    let numbers = phoneNumber.replace(/[^0-9]/g, "")
                        .replace(/^(\d{2,3})(\d{3,4})(\d{4})$/, `$1-$2-$3`);
                    phoneInput.value = numbers;
                }
                return true;
            }
        }

        //이메일 형식 검사
        function checkEmail(){
            const email = document.getElementById('edit-email').value.trim();
            const msgBox = document.getElementById('email-check-msg');

            const emailRule = /^[A-Za-z0-9._-]+@[A-Za-z0-9-]+(\.[A-Za-z]{2,})+$/;
            if(!emailRule.test(email)){
                msgBox.style.display = "block"
                msgBox.textContent = "! 올바른 이메일 형식을 입력해주세요."
                msgBox.style.color = "red";
                return false;
            } else if (email.length > 20) {
                msgBox.style.display = "block"
                msgBox.textContent = "! 이메일은 20자 이내로 입력해주세요."
                msgBox.style.color = "red";
                return false;
            } else {
                msgBox.style.display = "none"
                msgBox.textContent = ""
                msgBox.style.color = "";
                return true;
            }
        }

        async function validateAll() {
            const passPwd = await checkPwd();
            const passCheckPwd = checkCheckPwd();
            const passEmail = checkEmail();
            const passPhone = checkPhone();
            const passAddr = checkAddress()

            return passPwd && passCheckPwd && passEmail && passPhone && passAddr;
        }

        //------------------------------------------------------------------------------------------------------------------
        document.addEventListener('DOMContentLoaded', () => {
            //엔터 눌러도 비밀번호 확인
            const pwdInput = document.getElementById("member-current-pwd");

            pwdInput.addEventListener("keydown", (e) => {
                if (e.key === "Enter") {
                    checkCurrentPwd();
                }
            });

            //정보 수정 폼 제출 전 확인
            const form = document.getElementById('member-edit-form');
            form.addEventListener("submit", async function(e) {
                e.preventDefault();

                const pass = await validateAll();
                if (!pass) {
                    alert("모든 내용을 정확히 입력해주세요.");
                    return;
                }

                this.submit();
            });

            //대기중 상태일때 정보수정/탈퇴 막기
            const status = "${member.memberStatus}";
            const editBtn = document.getElementById("edit-btn");
            const withdrawLink = document.getElementById("withdrawBtn");

            if(status === "PENDING"){
                const disableTargets = [editBtn, withdrawLink];

                disableTargets.forEach(target => {
                    if(!target) return;

                    target.removeAttribute("data-bs-toggle");
                    target.removeAttribute("data-bs-target");

                    target.addEventListener("click", e => {
                        e.preventDefault();
                        alert ("승인 처리 후 해당 기능 이용 가능합니다.");
                    })

                    target.classList.add("disabled-item");
                })
            } else {
                // 승인 상태일 때만 기능 연결
                editBtn.addEventListener("click", () => {
                    setValue('edit');
                });

                withdrawLink.addEventListener("click", () => {
                    setValue('withdraw');
                });
            }
        });

        //정보 수정 시 비밀번호 변경 area
        $(document).ready(function () {
            $("#toggle-pwd-area").on("click", function (){
                $("#pwd-area").toggle();

                if($("#pwd-area").is(":hidden")) {
                    $("#edit-password").val("");
                    $("#edit-password-check").val("");
                    $("#pwd-check-msg").text("").hide();
                    $("#checkpwd-check-msg").text("").hide();
                }
            });
        });
    </script>

    <%-- 메세지 올 경우 알림 --%>
    <c:if test="${not empty message}">
        <script>
            alert("${message}");
        </script>
    </c:if>
</head>
<body>
    <!-- 공통 헤더 -->
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <div id="mypage-container">

        <h2>내 정보</h2>

        <table>
            <tr>
                <th>아이디</th>
                <td>${member.memberId}</td>
            </tr>
            <tr>
                <th>이름</th>
                <td>${member.name}</td>
            </tr>
            <tr>
                <th>성별</th>
                <td>
                    <c:choose>
                        <c:when test="${member.gender == 'M'}">남자</c:when>
                        <c:when test="${member.gender == 'W'}">여자</c:when>
                        <c:otherwise>미입력</c:otherwise>
                    </c:choose>
                </td>
            </tr>
            <tr>
                <th>나이</th>
                <td>${member.age}</td>
            </tr>
            <tr>
                <th>주소</th>
                <td>[${member.zipCode}]<br/> ${member.addressBase}, <br/> ${member.addressDetail}</td>
            </tr>
            <tr>
                <th>이메일</th>
                <td>${member.email}</td>
            </tr>
            <tr>
                <th>전화번호</th>
                <td>${member.phone}</td>
            </tr>
            <tr>
                <th>가입일</th>
                <td>
                    <c:choose>
                        <c:when test="${not empty member.createdDate}">
                            ${fn:substring(member.createdDate, 0, 10)}
                        </c:when>
                        <c:otherwise>-</c:otherwise>
                    </c:choose>
                </td>
            </tr>
            <tr>
                <th>회원 구분</th>
                <td>
                    <c:choose>
                        <c:when test="${member.memberRole == 'ADMIN'}">관리자</c:when>
                        <c:when test="${member.memberRole == 'MEMBER'}">회원</c:when>
                        <c:otherwise>미입력</c:otherwise>
                    </c:choose>
                </td>
            </tr>
            <tr>
                <th>회원 상태</th>
                <td>
                    <c:choose>
                        <c:when test="${member.memberStatus == 'PENDING'}">대기중 (관리자 승인 후 서비스 이용이 가능합니다.)</c:when>
                        <c:when test="${member.memberStatus == 'APPROVED'}">승인</c:when>
                        <c:when test="${member.memberStatus == 'REJECTED'}">거절</c:when>
                        <c:when test="${member.memberStatus == 'DELETED'}">삭제</c:when>
                        <c:when test="${member.memberStatus == 'WITHDRAWN'}">탈퇴</c:when>
                        <c:otherwise>미입력</c:otherwise>
                    </c:choose>
                </td>
            </tr>
        </table>

        <%--정보 수정, 탈퇴하기 버튼--%>
        <div class="btn-area">
            <button type="button"
                    id="edit-btn"
                    data-bs-toggle="modal"
                    data-bs-target="#verifyPwdModal"
                    > 내 정보 수정</button>
            <a id="withdrawBtn"
               data-bs-toggle="modal"
               data-bs-target="#verifyPwdModal">탈퇴하기</a>
        </div>


    </div>

    <%--비밀번호 확인 모달--%>
    <div class="modal fade" id="verifyPwdModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content verify-modal">

                <div class="modal-header">
                    <h5 class="modal-title">비밀번호 확인</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body text-center">
                    <p class="verify-msg">본인 확인을 위해 비밀번호를 입력해주세요.</p>
                    <input type="password" name="memberCurrentPwd" id="member-current-pwd" class="verify-input" placeholder="비밀번호" oninput="checkInput()" required>
                    <div class="msgBox" id="current-pwd-check-msg"></div>
                </div>

                <div class="modal-footer justify-content-center">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                    <button type="button" class="btn btn-primary" id="check-current-pwd" onclick="checkCurrentPwd()">확인</button>
                </div>

            </div>
        </div>
    </div>

    <%--정보 수정 모달--%>
    <div class="modal fade" id="editModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">

                <div class="modal-header">
                    <h5 class="modal-title" id="editModalLabel">정보 수정</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>


                <div class="modal-body">
                    <form action="<c:url value='/member/edit'/>" method="post" id="member-edit-form">

                        <!-- 아이디 (수정 불가) -->
                        <div class="edit-input-group">
                            <input type="text"
                                   id="edit-memberId"
                                   class="edit-input"
                                   value="${member.memberId}"
                                   disabled>
                        </div>

                        <!-- 이름 (수정 불가) -->
                        <div class="edit-input-group">
                            <input type="text"
                                   id="edit-name"
                                   class="edit-input"
                                   value="${member.name}"
                                   disabled>
                        </div>


                        <button type="button" id="toggle-pwd-area" class="toggle-pwd-area">
                            비밀번호 변경
                        </button>



                        <div id="pwd-area" style="display: none;">

                            <!-- 비밀번호 -->
                            <div class="edit-input-group">
                                <input type="password"
                                       id="edit-password"
                                       name="memberPwd"
                                       class="edit-input"
                                       oninput="checkPwd()"
                                       placeholder="새로운 비밀번호">
                            </div>

                            <!-- 비밀번호 확인 -->
                            <div class="edit-input-group">
                                <input type="password"
                                       id="edit-password-check"
                                       class="edit-input"
                                       oninput="checkCheckPwd()"
                                       placeholder="비밀번호 확인">
                            </div>
                            <div class="msgBox" id="pwd-check-msg" style="display: none"></div>
                            <div class="msgBox" id="checkpwd-check-msg" style="display: none"></div>
                        </div>

                        <!-- 성별 (라디오 버튼, 기존 값 선택) -->
                        <div class="edit-input-group">
                            <span class="edit-label">성별</span>
                            <label for="man" style="margin-right:8px; font-size:13px;">
                                <input type="radio"
                                       id="man"
                                       name="gender"
                                       value="M"
                                       <c:if test="${member.gender == 'M'}">checked</c:if>>
                                남자
                            </label>

                            <label for="woman" style="font-size:13px;">
                                <input type="radio"
                                       id="woman"
                                       name="gender"
                                       value="W"
                                       <c:if test="${member.gender == 'W'}">checked</c:if>>
                                여자
                            </label>
                        </div>

                        <!-- 나이 (셀렉트 박스, 기존 나이 selected) -->
                        <div class="edit-input-group">
                            <span class="edit-label">나이</span>
                            <select id="edit-age" name="age" class="edit-input" required>
                                <c:forEach var="i" begin="20" end="99">
                                    <option value="${i}"
                                            <c:if test="${member.age == i}">selected</c:if>>
                                            ${i}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- 주소 - 우편번호 -->
                        <div class="edit-input-group">
                            <span class="edit-label">우편번호</span>
                            <input type="text"
                                   id="edit-zipCode"
                                   name="zipCode"
                                   class="edit-input"
                                   placeholder="우편번호"
                                   value="${member.zipCode}"
                                   readonly>
                            <button type="button"
                                    id="btn-search-address"
                                    class="edit-btn-small"
                                    onclick="searchAddress()" >
                                검색
                            </button>
                        </div>

                        <!-- 기본 주소 -->
                        <div class="edit-input-group">
                            <input type="text"
                                   id="edit-addressBase"
                                   name="addressBase"
                                   class="edit-input"
                                   value="${member.addressBase}"
                                   readonly>
                        </div>

                        <!-- 상세 주소 -->
                        <div class="edit-input-group">
                            <span class="edit-label">(상세주소)</span>
                            <input type="text"
                                   id="edit-addressDetail"
                                   name="addressDetail"
                                   class="edit-input"
                                   value="${member.addressDetail}"
                                   onblur="checkAddress()"
                                    placeholder="상세주소">
                        </div>
                        <div class="msgBox" id="address-check-msg" style="display: none"></div>

                        <!-- 전화번호 -->
                        <div class="edit-input-group">
                            <input type="text"
                                   id="edit-phone"
                                   name="phone"
                                   class="edit-input"
                                   value="${member.phone}"
                                   onblur="checkPhone()"
                                    placeholder="전화번호">
                        </div>
                        <div class="msgBox" id="phone-check-msg" style="display: none"></div>

                        <!-- 이메일 -->
                        <div class="edit-input-group">
                            <input type="email"
                                   id="edit-email"
                                   name="email"
                                   class="edit-input"
                                   value="${member.email}"
                                   onblur="checkEmail()"
                                   placeholder="이메일">
                        </div>
                        <div class="msgBox" id="email-check-msg" style="display: none"></div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                            <button type="submit" class="btn btn-primary">저장</button>
                        </div>

                    </form>
                </div>
            </div>
        </div>
    </div>


</body>
</html>
