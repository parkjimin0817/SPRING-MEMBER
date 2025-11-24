<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>페이지를 찾을 수 없습니다</title>
    <style>
        body {
            margin: 0;
            font-family: "Noto Sans KR", Arial, sans-serif;
            background: linear-gradient(to bottom, #f6f9fc, #e9f3ff);
            text-align: center;
            padding: 60px 0 0;
            color: #333;
        }

        .container {
            width: 800px;
            margin: 0 auto;
            padding: 20px;
            display: flex;
            justify-content: space-around;
        }

        #div-left{
            padding-top: 55px;
            width: 400px;
        }

        .winter-img {
            width: 400px;
            filter: drop-shadow(0 4px 10px rgba(0,0,0,0.15));
            border-radius: 8px;
        }

        h1 {
            font-size: 28px;
            color: #2b4a73;
            margin-bottom: 12px;
        }

        p {
            font-size: 15px;
            color: #5f6e82;
            margin: 6px 0;
            line-height: 1.6;
        }

        .btn-home {
            display: inline-block;
            margin-top: 22px;
            padding: 10px 20px;
            background-color: #4c89ff;
            color: white;
            font-weight: bold;
            border-radius: 6px;
            text-decoration: none;
            transition: 0.2s ease-in-out;
        }

        .btn-home:hover {
            background-color: #3a6ed6;
        }

        /* 눈 내리는 느낌(옵션) */
        .snow {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            background-image: url("${pageContext.request.contextPath}/resources/img/snow.png");
            background-size: contain;
            opacity: 0.1;
            animation: snow 12s linear infinite;
        }

        @keyframes snow {
            0% { background-position: 0px 0px; }
            100% { background-position: 500px 1000px; }
        }
    </style>
</head>

<body>

<div class="snow"></div>

<div class="container">
    <img src="${pageContext.request.contextPath}/resources/img/404.png"
         alt="404 이미지"
         class="winter-img">
    <div id="div-left">

        <h1>페이지를 찾을 수 없습니다</h1>

        <p>입력하신 주소가 존재하지 않거나<br>이동되었을 수 있습니다.</p>
        <p>주소를 다시 확인하시거나 아래 버튼을 눌러<br>홈으로 이동해주세요.</p>
        <p style="font-size: 13px">관리자 문의 : 1515-1515</p>

        <a class="btn-home" href="${pageContext.request.contextPath}/">홈으로 돌아가기</a>
    </div>
</div>

</body>
</html>
