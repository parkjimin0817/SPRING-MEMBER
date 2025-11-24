<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>

    <style>
        /* ===== 회원가입 레이아웃 ===== */
        #outer {
            width: 300px;                /* 로그인과 동일 폭 */
            margin: 30px auto 20px;     /* 가운데 정렬 + 상단 여백 */
            display: flex;
            flex-direction: column;
            row-gap: 12px;               /* 섹션 간격 */
            padding: 0;
        }

        #title{
            text-align: center;
            font-size: 24px;
            margin: 20px 0 0;
        }

        /* 섹션 공통 (div1~div4) */
        #div1, #div2, #div3, #div4 {
            display: flex;
            flex-direction: column;
            align-items: center;
            row-gap: 10px;
            margin-bottom: 20px;
        }

        /* 입력 프레임 */
        .input-group {
            width: 300px;                /* 로그인과 동일 폭 */
            min-height: 40px;
            display: flex;
            align-items: center;
            gap: 8px;
            border: 1px solid #ccc;
            padding: 0 0 0 10px;
            background: #fff;
            border-radius: 5px;
        }

        /* 실제 입력 요소 */
        .input-group input[type="text"],
        .input-group input[type="password"],
        .input-group input[type="email"],
        .input-group input[type="tel"],
        .input-group select {
            flex: 1;
            border: none;
            outline: none;
            background: transparent;
            height: 38px;                /* 입력 높이 */
            font-size: 14px;
        }

        /* 우편번호 검색 버튼 등 작은 버튼 */
        .input-group button {
            font-size: 12px;
            padding: 6px 10px;
            background-color: #00ac00;
            color: white;
            border-radius: 5px;
            cursor: pointer;
        }

        /* 성별 선택 박스도 동일 폭 */
        #gender-div {
            width: 300px;
            min-height: 40px;
            display: flex;
            align-items: center;
            gap: 8px;
            border: 1px solid #ccc;
            padding: 6px 10px;
            background: #fff;
            border-radius: 4px;
            font-size: 14px;
        }

        /* 메시지 영역도 동일 폭 */
        .msgBox {
            width: 300px;
            min-height: 16px;
            margin: 0;
            font-size: 11px;
            line-height: 1.3;
            color: red;
            transition: color 0.2s, opacity 0.2s;
        }

        #submitBtn {
            width: 300px;
            height: 40px;
            background-color: #00ac00;
            color: white;
            font-size: 16px;
            margin-top: 10px;
            transition: background-color 0.2s ease;
        }

        #submitBtn:hover {
            background-color: #008800;
        }
    </style>

    <%--다음 주소 api--%>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

    <script>
        //아이디 중복 확인
        async function checkId(){
            const memberId = document.getElementById('member-id').value.trim();
            const msgBox = document.getElementById('id-check-msg');

            //아이디 형식 검사 - 영어 대소문자 & 숫자 & 20자내
            const idRule = /^(?=.*[A-Za-z])[A-Za-z0-9]{5,20}$/ //영어 대소문자, 숫자, 5-20자
            if(!idRule.test(memberId)){
                msgBox.style.display = "block"
                msgBox.textContent = "! 아이디는 영어 대소문자, 숫자를 포함한 5~20자로 입력해주세요."
                msgBox.style.color = "red";
                return false;
            }
            //서버 요청
            try {
                const response = await fetch("/member/api/checkId?id=" + memberId);
                const result = await response.json();

                if(result.error){
                    alert(result.message);
                    return;
                }

                if (result.isDuplicate) {
                    msgBox.style.display = "block"
                    msgBox.textContent = "! 사용중인 아이디입니다."
                    msgBox.style.color = "red";
                    return false;
                } else {
                    msgBox.style.display = "block"
                    msgBox.textContent = "! 사용 가능한 아이디입니다."
                    msgBox.style.color = "green";
                    return true;
                }
            } catch (err) {
                console.error(err);
                alert('네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
            }
        }

        //비밀번호 형식 검사
        function checkPwd(){
            const memberPwd = document.getElementById('member-pwd').value.trim();
            const msgBox = document.getElementById('pwd-check-msg');

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
                return true;
            }
        }

        //이름 형식 검사
        function checkName(){
            const name = document.getElementById('name').value.trim();
            const msgBox = document.getElementById('name-check-msg');

            const nameRule = /^[가-힣]{1,10}$/;
            if(!nameRule.test(name)){
                msgBox.style.display = "block"
                msgBox.textContent = "! 이름은 한글 10자 이내로 입력해주세요."
                msgBox.style.color = "red";
                return false;
            } else {
                msgBox.style.display = "none"
                msgBox.textContent = ""
                msgBox.style.color = "";
                return true;
            }
        }

        //이메일 형식 검사
        function checkEmail(){
            const email = document.getElementById('email').value.trim();
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

        //전화번호 형식 검사
        function checkPhone(){
            const phoneInput = document.getElementById("phone");
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

        //다음 주소 검색
        function searchAddress() {
            new daum.Postcode({
                oncomplete: function (data) {
                    document.getElementById('zipcode').value = data.zonecode;
                    document.getElementById('address-base').value = data.address;
                    document.getElementById('address-detail').focus();
                }
            }).open();
        }

        //주소 형식 검사
        function checkAddress(){
            const zipCode = document.getElementById("zipcode").value.trim();
            const addressBase = document.getElementById("address-base").value.trim();
            const addressDetail = document.getElementById("address-detail").value.trim();
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

        //최종 체크
        document.addEventListener('DOMContentLoaded', () => {
            const form = document.getElementById('signup-form');
            form.addEventListener("submit", async function(e) {
                e.preventDefault();

                const pass = await validateAll();
                if (!pass) {
                    alert("모든 내용을 정확히 입력해주세요.");
                    return;
                }

                this.submit();
            });

            async function validateAll() {
                const passId = await checkId();
                const passPwd = checkPwd();
                const passName = checkName();
                const passEmail = checkEmail();
                const passPhone = checkPhone();
                const passAddr = checkAddress();

                return passId && passPwd && passName && passEmail && passPhone && passAddr;
            }
        });
    </script>

    <c:if test="${not empty message}">
        <script>
            alert("${message}");
        </script>
    </c:if>


</head>

<body>

<%--공통 헤더--%>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<h1 id="title">회원가입</h1>


<!-- BindingResult 객체를 request에서 꺼내와서 변수 br에 저장 -->
<c:set var="br" value="${requestScope['org.springframework.validation.BindingResult.member']}" />


<div id="outer">
    <form action="<c:url value='/member/register'/>" method="post" id="signup-form">

        <div id="div1">
            <div class="input-group">
                <input type="text" name="memberId" id="member-id" value="${member.memberId}" onblur="checkId()" placeholder="아이디" required>
            </div>
            <div class="input-group">
                <input type="password" name="memberPwd" id="member-pwd" oninput="checkPwd()" placeholder="비밀번호" required>
            </div>
            <div class="msgBox" id="id-check-msg" style="display: none"></div>
            <div class="msgBox" id="pwd-check-msg" style="display: none"></div>
            <!-- 서버 검증 메시지 (memberId용) -->
            <c:if test="${not empty br and br.hasFieldErrors('memberId')}">
                <div class="msgBox">
                    <c:forEach var="err" items="${br.fieldErrors}">
                        <c:if test="${err.field == 'memberId'}">${err.defaultMessage}</c:if>
                    </c:forEach>
                </div>
            </c:if>
            <!-- 서버 검증 메시지 (memberPwd용) -->
            <c:if test="${not empty br and br.hasFieldErrors('memberPwd')}">
                <div class="msgBox">
                    <c:forEach var="err" items="${br.fieldErrors}">
                        <c:if test="${err.field == 'memberPwd'}">${err.defaultMessage}</c:if>
                    </c:forEach>
                </div>
            </c:if>
        </div>


        <div id="div2">
            <div class="input-group">
                <input type="text" name="name" id="name" value="${member.name}" onblur="checkName()" placeholder="이름">
            </div>
            <div class="input-group">
                <input type="email" name="email" id="email" value="${member.email}" onblur="checkEmail()" placeholder="이메일">
            </div>
            <div class="input-group">
                <input type="text" name="phone" id="phone" value="${member.phone}" onblur="checkPhone()" placeholder="전화번호('-'제외)" maxlength="13" inputmode="numeric">
            </div>
            <div class="msgBox" id="name-check-msg" style="display: none"></div>
            <div class="msgBox" id="email-check-msg" style="display: none"></div>
            <div class="msgBox" id="phone-check-msg" style="display: none"></div>
            <!-- 서버 검증 메시지 (name용) -->
            <c:if test="${not empty br and br.hasFieldErrors('name')}">
                <div class="msgBox">
                    <c:forEach var="err" items="${br.fieldErrors}">
                        <c:if test="${err.field == 'name'}">${err.defaultMessage}</c:if>
                    </c:forEach>
                </div>
            </c:if>
            <!-- 서버 검증 메시지 (email용) -->
            <c:if test="${not empty br and br.hasFieldErrors('email')}">
                <div class="msgBox">
                    <c:forEach var="err" items="${br.fieldErrors}">
                        <c:if test="${err.field == 'email'}">${err.defaultMessage}</c:if>
                    </c:forEach>
                </div>
            </c:if>
            <!-- 서버 검증 메시지 (phone용) -->
            <c:if test="${not empty br and br.hasFieldErrors('phone')}">
                <div class="msgBox">
                    <c:forEach var="err" items="${br.fieldErrors}">
                        <c:if test="${err.field == 'phone'}">${err.defaultMessage}</c:if>
                    </c:forEach>
                </div>
            </c:if>
        </div>


        <div id="div3">
            <div class="input-group">
                <input type="text" name="zipCode" id="zipcode" value="${member.zipCode}" placeholder="우편번호" readonly>
                <button type="button" onclick="searchAddress()" >주소 검색</button>
            </div>
            <div class="input-group">
                <input type="text" name="addressBase" id="address-base" value="${member.addressBase}" placeholder="도로명 주소" readonly>
            </div>
            <div class="input-group">
                <input type="text" name="addressDetail" id="address-detail" value="${member.addressDetail}" onblur="checkAddress()" placeholder="상세 주소 (40자 이내)">
            </div>
            <div class="msgBox" id="address-check-msg" style="display: none"></div>
            <!-- 서버 검증 메시지 (우편번호) -->
            <c:if test="${not empty br and br.hasFieldErrors('zipCode')}">
                <div class="msgBox">
                    <c:forEach var="err" items="${br.fieldErrors}">
                        <c:if test="${err.field == 'zipCode'}">${err.defaultMessage}</c:if>
                    </c:forEach>
                </div>
            </c:if>
            <!-- 서버 검증 메시지 (기본주소) -->
            <c:if test="${not empty br and br.hasFieldErrors('addressBase')}">
                <div class="msgBox">
                    <c:forEach var="err" items="${br.fieldErrors}">
                        <c:if test="${err.field == 'addressBase'}">${err.defaultMessage}</c:if>
                    </c:forEach>
                </div>
            </c:if>
            <!-- 서버 검증 메시지 (상세주소) -->
            <c:if test="${not empty br and br.hasFieldErrors('addressDetail')}">
                <div class="msgBox">
                    <c:forEach var="err" items="${br.fieldErrors}">
                        <c:if test="${err.field == 'addressDetail'}">${err.defaultMessage}</c:if>
                    </c:forEach>
                </div>
            </c:if>
        </div>


        <div id="div4">
            <div class="input-group" id="gender-div">
                성별 :
                <label for="man">남자</label>
                <input type="radio" id="man" name="gender" value="M"
                       <c:if test="${member.gender == 'M'}">checked</c:if>
                >
                <label for="woman">여자</label>
                <input type="radio" id="woman" name="gender" value="W"
                       <c:if test="${member.gender == 'W'}">checked</c:if>
                >
            </div>
            <div class="input-group">
                <select id="age" name="age" required>
                    <option value="">나이 선택</option>
                    <c:forEach var="i" begin="20" end="99">
                        <option value="${i}"
                                <c:if test="${member.age == i}">selected</c:if>
                        >${i}</option>
                    </c:forEach>
                </select>
            </div>
        </div>

        <button type="submit" id="submitBtn">회원가입</button>
    </form>
</div>
</body>
</html>
