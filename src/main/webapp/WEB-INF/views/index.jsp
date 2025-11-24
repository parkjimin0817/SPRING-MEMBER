<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>HOME</title>

    <%-- 이 페이지 css --%>
    <style>
        /* ===== 로그인 버튼 ===== */
        #loginBtn {
            background-color: #00ac00;
            color: white;
            border: none;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.2s ease;
        }
        #loginBtn:hover {
            background-color: #008800;
        }

        /* ===== 회원가입 링크 ===== */
        .option-link {
            display: block;
            text-align: center;
            margin-top: 5px;
            font-size: 14px;
            color: black;
            text-decoration: none;
        }

        .option-link:hover {
            text-decoration: underline;
        }

        #login-div{
            width: 300px;               /* 고정 너비 */
            margin: 100px auto 20px;    /* 위 100px, 좌우 가운데 정렬 */
            display: flex;
            flex-direction: column;
            gap: 10px;
            align-items: center;
        }

        #login-div form {
            width: 300px;               /* 입력창과 동일한 너비 */
            margin: 0 auto;             /* 가운데 정렬 */
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        #login-div form input {
            width: 100%;                /* 부모(form) 너비에 맞춤 */
            height: 50px;
            padding: 5px 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
            box-sizing: border-box;     /* padding 포함해서 크기 계산 */
        }

        .msgBox {
            width: 300px;
            min-height: 16px;
            margin: 0;
            font-size: 12px;
            line-height: 1.3;
            color: red;
            transition: color 0.2s, opacity 0.2s;
        }

        #option-div{
            display: flex;
        }

        .divider{
            margin: 0 6px;
            color: #ccc; /* 원하면 색 바꾸기 */
            vertical-align: center;
        }
    </style>

    <script>
        //로그인 입력 확인
        function validateLogin(){
            const id = document.getElementById("member-id").value.trim();
            const pwd = document.getElementById("member-pwd").value.trim();
            const msgBox = document.getElementById("check-msg");

            if(!id || !pwd) {
                msgBox.style.display = "block";
                msgBox.textContent = "! 아이디 또는 비밀번호를 정확히 입력해주세요.";
                msgBox.style.color = "red";
                return false;
            }
            msgBox.style.display = "none";
            msgBox.textContent = "";
            msgBox.style.color = "";
            return true;
        }


    </script>

    <c:if test="${not empty message}">
        <script>
            alert('${message}');
        </script>
    </c:if>

</head>
<body>

<%--공통 헤더--%>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<!-- 로그인 폼 -->
<div id="login-div">
    <form action="<c:url value="/member/login"/>" method="post" onsubmit="return validateLogin()">
        <input type="text" name="memberId" id="member-id" value="${memberId}" placeholder="아이디">
        <input type="password" name="memberPwd" id="member-pwd" placeholder="비밀번호">
        <div class="msgBox" id="check-msg" style="display: none"></div>
        <button type="submit" class="btn" id="loginBtn">로그인</button>
    </form>
    <div id="option-div">
        <%--회원가입 링크--%>
        <a id="register-link" class="option-link" href="<c:url value="/member/register"/>">회원가입</a>
        <span class="divider">|</span>
        <%--비밀번호 찾기--%>
        <a id="finePwd-link" class="option-link" href="<c:url value="/member/findPwd"/>">비밀번호 찾기</a>
    </div>
</div>

</body>
</html>