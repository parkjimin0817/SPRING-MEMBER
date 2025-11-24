<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>비밀번호 찾기</title>

    <style>
        #title{
            text-align: center;
            font-size: 24px;
            margin: 20px 0 0;
        }


        /* 전체 컨테이너 */
        .find-container {
            width: 330px;
            margin: 80px auto;
            background: #fff;
            padding: 15px 22px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            box-sizing: border-box;
            text-align: center;
        }

        #title {
            font-size: 20px;
            margin-bottom: 20px;
            color: #333;
        }

        .input-div{
            margin-bottom: 8px;
        }

        /* 인풋 공통 스타일 */
        .find-input {
            width: 100%;
            height: 35px;              /* 더 얇게 */
            padding: 0 10px;
            margin-bottom: 5px;
            border-radius: 5px;
            border: 1px solid #ccc;
            font-size: 13px;
            outline: none;
            box-sizing: border-box;
        }

        /* 버튼 공통 */
        .find-btn,
        .btn-small {
            width: 100%;
            height: 36px;             /* 더 얇게 */
            margin-top: 5px;
            border-radius: 5px;
            font-size: 14px;
            color: #fff;
            border: none;
            cursor: pointer;
            display: block;
        }

        /* 메인 버튼 색 (비번 변경) */
        .find-btn {
            background: #4A73E8 ;   /* 우선순위 ↑ */
        }

        .find-btn:hover {
            background: #3c61c8;
        }

        /* 작은 버튼 */
        .btn-small {
            background: #02a602;
        }

        .btn-small:hover {
            background: #109c10 ;
        }

        .btn-small:disabled {
            background: #959595;
        }

        /* 메시지 영역도 동일 폭 */
        .msgBox {
            text-align: left;
            width: 290px;
            min-height: 16px;
            margin: 0;
            font-size: 11px;
            line-height: 1.3;
            color: red;
            transition: color 0.2s, opacity 0.2s;
        }

    </style>

    <script>
        let memberId = null;
        let memberEmail = null;

        document.addEventListener('DOMContentLoaded', () => {
            //엔터 눌러도 인풋값들 확인
            const idInput = document.getElementById("memberId");
            idInput.addEventListener("keydown", (e) => {
                if (e.key === "Enter") {
                    findPwd_verifyId();
                }
            });
            const emailInput = document.getElementById("email");
            emailInput.addEventListener("keydown", (e) => {
                if (e.key === "Enter") {
                    sendCode();
                }
            });
            const codeInput = document.getElementById("code");
            codeInput.addEventListener("keydown", (e) => {
                if (e.key === "Enter") {
                    verifyCode();
                }
            });
        })



        async function findPwd_verifyId() {
            const idInput = document.getElementById("memberId");
            memberId = idInput.value.trim();

            if(memberId === "") {
                alert("아이디를 입력해주세요.")
                return;
            }

            try{
                const response = await fetch ('/member/api/findPwd/verifyId', {
                    method: "POST",
                    headers: {"Content-Type": "application/json"},
                    body: JSON.stringify({memberId: memberId})
                });

                const result = await response.json();

                if(result.error) {
                    alert(result.message);
                    return;
                }

                if(result.success) {
                    document.getElementById("email-area").style.display = "block";
                    idInput.disabled = true;
                    document.getElementById("verifyIdBtn").disabled = true;
                    document.getElementById("email").focus();
                } else {
                    alert(result.message);
                }
            } catch (err) {
                console.error(err);
                alert('네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
            }
        }

        let isSending = false;
        async function sendCode() {
            const emailInput = document.getElementById("email");
            const email = emailInput.value.trim();
            memberEmail = email;

            const sendCodeBtn = document.getElementById("sendCodeBtn");
            const sendCodeText = sendCodeBtn.textContent;

            if(email === "") {
                alert("이메일을 입력해주세요.")
                return;
            }

            sendCodeBtn.disabled = true;
            sendCodeBtn.textContent = " 전송 중...";

            try{
                const response = await fetch ('/member/api/findPwd/sendCode', {
                    method: "POST",
                    headers: {"Content-Type": "application/json"},
                    body: JSON.stringify({email: email, memberId: memberId})
                });

                const result = await response.json();

                if(result.error){
                    alert(result.message);
                    sendCodeBtn.disabled = false;
                    sendCodeBtn.textContent = sendCodeText;
                    return;
                }

                if(result.success) {
                    document.getElementById("code-area").style.display = "block";
                    document.getElementById("code").focus();
                    emailInput.disabled = true;
                    sendCodeBtn.textContent = "전송 완료"
                } else {
                    alert(result.message);
                    sendCodeBtn.disabled = false;
                    sendCodeBtn.textContent = sendCodeText;
                }
            } catch (err) {
                console.error(err);
                alert('네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
                sendCodeBtn.disabled = false;
                sendCodeBtn.textContent = sendCodeText;
            }
        }

        async function verifyCode(){
            const codeInput = document.getElementById("code");
            const code = codeInput.value.trim();
            const msgBox = document.getElementById("verify-code-msg");
            const sendCodeBtn = document.getElementById("sendCodeBtn");
            const verifyCodeBtn = document.getElementById("verifyCodeBtn");

            if(code === ""){
                msgBox.style.display = "block";
                msgBox.textContent = "! 인증코드를 입력해주세요.";
                msgBox.style.color = "red";
                return false;
            }

            try {
                const response = await fetch("/member/api/findPwd/verifyCode", {
                    method: "POST",
                    headers: {"Content-Type": "application/json"},
                    body: JSON.stringify({
                        memberId: memberId,
                        email: memberEmail,
                        code: code
                    })
                });

                const result = await response.json();

                if(result.error){
                    alert(result.message);
                    return;
                }

                if (result.success) {
                    msgBox.style.display = "none";

                    const pwdArea = document.getElementById("newpwd-area");
                    pwdArea.style.display = 'block';

                    codeInput.disabled = true;
                    verifyCodeBtn.disabled = true;

                    return true;
                } else {
                    msgBox.style.display = "block";
                    msgBox.textContent = result.message;
                    msgBox.style.color = "red";
                }

                if(result.resendAvailable) {
                    sendCodeBtn.disabled = false;
                    sendCodeBtn.textContent = "인증번호 재전송";
                    codeInput.value = "";
                }

                return false;
            } catch (error) {
                console.error("에러 :" + error);
                alert('네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');

                return false;
            }
        }

        async function checkPwd(){
            const newPwd = document.getElementById('newPwd').value.trim();
            const msgBox = document.getElementById('pwd-msg');

            //비밀번호 형식 검사 - 영어 대소문자 & 숫자 & 특수문자 & 20자내
            const pwdRule =  /^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{8,20}$/; //영어 대소문자, 숫자, 특수문자 8-20자
            if(!pwdRule.test(newPwd)){
                msgBox.style.display = "block"
                msgBox.textContent = "! 비밀번호는 영어, 숫자, 특수문자를 포함한 8~20자로 입력해주세요."
                msgBox.style.color = "red";
                return false;
            } else {
                msgBox.style.display = "none"
                msgBox.textContent = "";
                msgBox.style.color = "";
            }

            try {
                const response = await fetch("/member/api/findPwd/checkOldPwd", {
                    method: "POST",
                    headers: {"Content-Type" : "application/json"},
                    body: JSON.stringify({newPwd : newPwd})
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
                        msgBox.textContent = "! 이전 비밀번호와 동일한 비밀번호는 사용할 수 없습니다.";
                        return false;
                    } else {
                        msgBox.style.display= "none";
                        msgBox.textContent = "";
                        msgBox.style.color = "";
                        return true;
                    }
                } else {
                    alert(result.message);
                    return false;
                }
            } catch (error) {
                console.error('에러' + error);
                alert('네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
                return false;
            }

        }

        function checkConfirmPwd(){
            const newPwd = document.getElementById('newPwd').value.trim();
            const confirmPwd = document.getElementById('confirmPwd').value.trim();
            const msgBox = document.getElementById('confirmPwd-msg');

            //비밀번호 일치
            if(newPwd !== confirmPwd){
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

        async function changePwd(){
            if(!await checkPwd() || !checkConfirmPwd()){
                alert("비밀번호를 정확히 입력해주세요.");
                return;
            }

            const newPwd = document.getElementById('newPwd').value.trim();

            try {
                const response = await fetch("/member/api/findPwd/changePwd", {
                    method : 'POST',
                    headers : {"Content-Type" : "application/json"},
                    body : JSON.stringify({newPwd : newPwd})
                });

                const result = await response.json();

                //전역예외
                if(result.error){
                    alert(result.message);
                    return;
                }

                //비밀번호 변경 성공
                if(result.success) {
                    alert(result.message);
                    location.href = "/";
                } else {
                    //비밀번호 변경 실패
                    alert(result.message);
                }
            } catch(error) {
                console.error('에러 : ' + error);
                alert('네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
            }
        }

    </script>

</head>
<body>
<%--공통 헤더--%>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<div id="find-pwd-page">
    <div class="find-container">
        <h1 id="title">비밀번호 찾기</h1>

        <div id="id-area" class="input-div">
            <input type="text" id="memberId" class="find-input" placeholder="아이디 입력">
            <button type="button" id="verifyIdBtn" class="btn-small" onclick="findPwd_verifyId()">다음</button>
        </div>

        <div id="email-area" class="input-div" style="display: none"  >
            <input type="email" id="email" class="find-input" placeholder="이메일 입력">
            <button type="button" id="sendCodeBtn" class="btn-small" onclick="sendCode()">인증번호 보내기</button>
        </div>

        <div id="code-area" class="input-div" style="display: none" >
            <input type="text" id="code" class="find-input" placeholder="인증번호 입력">
            <div class="msgBox" id="verify-code-msg" style="display: none"></div>
            <button type="button" id="verifyCodeBtn" class="btn-small" onclick="verifyCode()">인증확인</button>
        </div>

        <div id="newpwd-area" class="input-div" style="display: none">
            <input type="password" id="newPwd" class="find-input" onblur="checkPwd()" placeholder="새 비밀번호">
            <div class="msgBox" id="pwd-msg" style="display: none"></div>
            <input type="password" id="confirmPwd" class="find-input" oninput="checkConfirmPwd()" placeholder="비밀번호 확인">
            <div class="msgBox" id="confirmPwd-msg" style="display: none"></div>
            <button type="button" class="find-btn" onclick="changePwd()">비밀번호 변경</button>
        </div>
    </div>
</div>
</body>
</html>
