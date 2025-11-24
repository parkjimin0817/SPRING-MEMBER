<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>회원가입 결과</title>

    <style>
        .complete-container {
            max-width: 500px;
            margin: 80px auto;
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            padding: 50px 40px;
            text-align: center;
        }

        .complete-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 20px;
        }

        .complete-message {
            font-size: 1rem;
            color: #555;
            margin-bottom: 40px;
        }

        .btn-home {
            background-color: #00ac00;
            color: white;
            padding: 10px 25px;
            border-radius: 8px;
            text-decoration: none;
            transition: background-color .2s;
        }
        .btn-home:hover {
            background-color: #008800;
        }

        .status-success {
            color: #198754;
        }

        /*멤버 정보*/
        .member-info-box {
            max-width: 500px;
            margin: 25px auto 40px;
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 20px 30px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            text-align: left;
        }

        .info-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            border: none;
            font-size: 14px;
        }

        .info-table th {
            text-align: left;
            width: 120px;
            padding: 6px 10px;
            color: #555;
            font-weight: 600;
            border: 1px solid #acacac;
        }

        .info-table td {
            padding: 6px 10px;
            color: #333;
            word-break: break-all;
            border: 1px solid #acacac;
        }

        .info-table tr:first-child th,
        .info-table tr:first-child td {
            border-top: none; /* 위쪽 제거 */
        }

        .info-table tr:last-child th,
        .info-table tr:last-child td {
            border-bottom: none; /* 아래쪽 제거 */
        }

        .info-table th:first-child,
        .info-table td:first-child {
            border-left: none; /* 왼쪽 제거 */
        }

        .info-table th:last-child,
        .info-table td:last-child {
            border-right: none; /* 오른쪽 제거 */
        }

    </style>
</head>
<body>

<%--공통 헤더--%>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<div class="complete-container">
    <div class="complete-title status-success">회원가입 성공</div>
    <p class="complete-message">가입이 완료되었습니다. 로그인 후 서비스를 이용해주세요.</p>
    <div class="member-info-box">
        <table class="info-table">
            <tr>
                <th>아이디</th>
                <td>${member.memberId}</td></tr>
            <tr>
                <th>이름</th>
                <td>${member.name}</td></tr>
            <tr>
                <th>성별</th>
                <td>
                    <c:choose>
                        <c:when test="${member.gender eq 'M'}">남자</c:when>
                        <c:when test="${member.gender eq 'W'}">여자</c:when>
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
                <td>[${member.zipCode}] <br> ${member.addressBase}<br> ${member.addressDetail} </td>
            </tr>
            <tr>
                <th>전화번호</th>
                <td>${member.phone}</td>
            </tr>
            <tr>
                <th>이메일</th>
                <td>${member.email}</td>
            </tr>
            <tr>
                <th>상태</th>
                <c:choose>
                    <c:when test="${member.memberStatus=='PENDING'}">
                        <td>대기중(승인 후 이용가능)</td>
                    </c:when>
                    <c:when test="${member.memberStatus=='APPROVED'}">
                        <td>승인</td>
                    </c:when>
                    <c:when test="${member.memberStatus=='REJECTED'}">
                        <td>거절</td>
                    </c:when>
                    <c:when test="${member.memberStatus=='DELETED'}">
                        <td>삭제</td>
                    </c:when>
                    <c:when test="${member.memberStatus=='WITHDRAWN'}">
                        <td>탈퇴</td>
                    </c:when>
                </c:choose>
            </tr>
        </table>
    </div>
    <a href="${pageContext.request.contextPath}/" class="btn-home">로그인하기</a>
</div>


</body>
</html>
