<%@ page import="com.brenex.pjm.security.LoginMember" %>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
<%@ page import="org.springframework.security.core.Authentication" %>
<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    // 로그인 여부 체크
    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

    Integer memberNo = null;
    String memberRole = null;

    if(authentication != null && authentication.getPrincipal() instanceof LoginMember){
        LoginMember loginMember = (LoginMember) authentication.getPrincipal();

        memberRole = loginMember.getMemberRole();
        memberNo = loginMember.getMemberNo();
    }
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>Title</title>

    <!-- BootStrap css-->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <%-- 공통 css --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">

    <style>
        
        #logo{
            cursor: pointer;
        }
        /* 관리자 메뉴바 전체 */
        .admin-nav {
            background: #d8d8d8;
            border-bottom: 1px solid #dee2e6;
            padding: 8px 20px;]
            margin-bottom: 20px;
        }

        /* 가로 메뉴 */
        .admin-menu {
            list-style: none;
            padding: 0;
            margin: 0;
            display: flex;
            gap: 20px;
        }

        /* 각 메뉴 아이템 */
        .admin-menu li a {
            text-decoration: none;
            font-weight: 600;
            color: #495057;
            padding: 6px 10px;
            border-radius: 6px;
            transition: all 0.15s ease-in-out;
        }

        /* 호버 */
        .admin-menu li a:hover {
            background: #e9ecef;
            color: #212529;
        }

    </style>
</head>
<body>
<header>
    <h1 onclick="location.href='${pageContext.request.contextPath}/'" id="logo" >SPRING 회원관리</h1>
        <% if (memberNo != null) { %>
        <form action="${pageContext.request.contextPath}/member/logout" method="post">
            <button type="submit" id="logoutBtn">로그아웃</button>
        </form>
        <% } %>
</header>
<%-- 🔥 ADMIN 전용 메뉴바 표시 --%>
<% if ("ADMIN".equals(memberRole)) { %>
<nav class="admin-nav">
    <ul class="admin-menu">
        <li>
            <a href="${pageContext.request.contextPath}/member/mypage">마이페이지</a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/memberlist">회원 목록</a>
        </li>
    </ul>
</nav>
<% } %>


</body>
</html>
