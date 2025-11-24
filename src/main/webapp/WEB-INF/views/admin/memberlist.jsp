<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>회원 목록</title>

    <style>

        .title{
            font-size: 24px;
            flex-grow: 1;
            text-align: center;
            margin: 20px auto;
        }

        #tool-div{
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-bottom: 5px;
        }

        #tool-div input {
            padding: 5px;
            width: 200px;
            height: 30px;
            font-size: 14px;
        }

        #search-div{
            display: flex;
            align-items: center;
            gap: 3px;
        }

        .table-wrap{
            width: 70%;
            margin: 20px auto;
        }

        .member-table{
            width:100%;
            border:1px solid #DDE3DD;
            box-shadow:0 2px 5px rgba(0,0,0,.15);
            border-collapse:separate;
            border-spacing:0;
            border-radius:5px;
            overflow:hidden;
            table-layout:fixed;          /* 🔒 열 폭 고정 */
            font-size:14px;
        }
        .member-table thead th{
            background: #7BAF7B;
            font-weight:700;
            padding: 10px 8px;
            color: #fff;
        }


        .member-table th, .member-table td{
            padding: 12px 8px;
            text-align: center;
            vertical-align: middle;
            border-top: 1px solid rgba(0,0,0,.08);
            border-right: 1px solid rgba(0,0,0,.08);
            background: #fff;
            white-space: normal;
            word-break: break-word;
            overflow: visible;
            text-overflow: clip;
            height: auto;
            min-height: 32px;
        }

        .member-table tbody tr:hover{  background:#E7F3E7; }

        #button-div{
            /*margin: 10px;*/
        }

        .member-table tbody tr.selected-row td {
            background-color: #f0f7f0;
        }

        .pagination{ display:flex; justify-content:center; margin:20px auto; }


        /* 모달 상세정보 테이블 스타일 */
        .modal-body table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }

        .modal-body table th,
        .modal-body table td {
            padding: 10px 12px;
            border-bottom: 1px solid #DDE3DD;
        }

        .modal-body table th {
            width: 30%;
            background-color: #F5F7F5;
            font-weight: 600;
            text-align: left;
            color: #333;
        }

        .modal-body table td {
            text-align: left;
            color: #555;
            word-break: break-word;
        }

        .modal-body table tr:last-child th,
        .modal-body table tr:last-child td {
            border-bottom: none;
        }

    </style>
    <%-- 부트스트랩 js--%>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <%-- 폰트오썸 아이콘--%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <script>
        const loginMemberNo = Number("${loginMemberNo}");
        let currentPage = 1;
        const pageSize = 10;

        let statusFilter;
        let roleFilter;
        let keywordInput;
        let searchBtn;
        let tbody;
        let pagination;

        function initElement(){
            statusFilter = document.getElementById('status-filter');
            roleFilter = document.getElementById('role-filter');
            keywordInput = document.getElementById('keyword-input');
            searchBtn = document.getElementById('search-btn');
            tbody = document.querySelector('tbody');
            pagination = document.querySelector('.pagination');
        }

        function initEvents(){
            //키워드 검색 시 키워드만 검색, 나머지 초기화
            searchBtn.addEventListener('click', () => {
                roleFilter.value =  '';
                statusFilter.value = '';
                refreshList(1);
            });

            //엔터 눌러도 검색 실행
            keywordInput.addEventListener("keydown", (e) => {
                if (e.key === "Enter") {
                    e.preventDefault();
                    roleFilter.value = '';
                    statusFilter.value = '';
                    refreshList(1);
                }
            });

            //옵션 선택 바뀌면 다시 조회
            [statusFilter, roleFilter].forEach(select => {
                select.addEventListener('change', () => {
                    refreshList(1);
                })
            });
        }

        //페이지, 상태 변경 시 리스트 불러오기
        document.addEventListener('DOMContentLoaded', () => {
            initElement();
            initEvents();
            refreshList();
        })

        //테이블 그리기
        function renderTable(list) {
            tbody.innerHTML = "";

            if(!list || list.length === 0 ) {
                const tr = document.createElement("tr");
                const td = document.createElement("td");
                td.colSpan = 12;
                td.textContent = "조회된 회원이 없습니다.";
                td.style.textAlign = "center";
                tr.appendChild(td);
                tbody.appendChild(tr);
                return;
            }

            list.forEach((m, index) => {
                const tr = document.createElement("tr");

                //체크박스
                const checkTd = document.createElement("td");
                const check = document.createElement("input");
                check.type = "checkbox";
                check.name = "check-member"
                check.value = m.memberNo;
                checkTd.appendChild(check);
                tr.appendChild(checkTd);

                // //비활성 회원일 경우
                const isInactive = ["DELETED", "WITHDRAWN"].includes(m.memberStatus);
                const age = isInactive? "-" : m.age;
                const password = isInactive ? "-" : m.memberPwd;
                const address = isInactive ? "-" : '[' + (m.zipCode || '') + ']' +  ' ' + (m.addressBase || '') + ', ' + (m.addressDetail || '');

                //텍스트
                const columns = [
                    index + 1,
                    m.name,
                    m.memberId,
                    password,
                    translateGender(m.gender),
                    age,
                    address,
                    m.phone,
                    m.email,
                    translateRole(m.memberRole)
                ];

                columns.forEach((text) => {
                    const td = document.createElement("td");
                    td.textContent = text;
                    tr.appendChild(td)
                });

                //상태 뱃지
                const tdStatus = document.createElement("td");
                tdStatus.innerHTML = translateStatusBadge(m.memberStatus);
                tdStatus.classList.add("member-status");
                tr.appendChild(tdStatus);

                //상세보기 아이콘
                const tdDetail = document.createElement("td");
                tdDetail.innerHTML = `<i class="fa-solid fa-circle-info" style="cursor:pointer"></i>`;
                tr.appendChild(tdDetail);

                tbody.appendChild(tr);
            });

            disableMyCheckbox();
            setShowDetail();
        }

        //페이지네이션 그리기
        function renderPagination(currentPage, totalPage) {
            pagination.innerHTML = '';

            //이전버튼
            const prev = document.createElement('li');
            prev.className = `page-item ${currentPage <= 1 ? 'disabled' : ''}`;
            prev.innerHTML = `<a class="page-link" href="#">
                                    <span>&laquo;</span>
                                  </a>`;
            if (currentPage > 1) {
                prev.addEventListener('click', (e) => {
                    e.preventDefault();
                    refreshList(currentPage - 1);
                });
            }
            pagination.appendChild(prev);

            // 페이지 번호
            for (let i = 1; i <= totalPage; i++) {
                const li = document.createElement('li');
                li.className = 'page-item ' + (i === currentPage ? 'active' : '');
                li.innerHTML = '<a class="page-link" href="#">' + i + '</a>';
                li.addEventListener('click', (e) => {
                    e.preventDefault();
                    refreshList(i);
                });
                pagination.appendChild(li);
            }

            // 다음 버튼
            const next = document.createElement('li');
            next.className = `page-item ${currentPage >= totalPage ? 'disabled' : ''}`;
            next.innerHTML = `<a class="page-link" href="#">
                                    <span>&raquo;</span>
                                  </a>`;
            if (currentPage < totalPage) {
                next.addEventListener('click', (e) => {
                    e.preventDefault();
                    refreshList(currentPage + 1);
                });
            }
            pagination.appendChild(next);
        }


        //서버에서 멤버 리스트 불러오기
        async function getMemberList(page, pageSize, status, role, keyword){

            const response = await fetch(
                "/admin/api/memberlist"
                + "?page=" + page
                + "&pageSize=" + pageSize
                + "&status=" + encodeURIComponent(status || "")
                + "&role=" + encodeURIComponent(role || "")
                + "&keyword=" + encodeURIComponent(keyword || "")
            );

            const result =  await response.json();

            if(result.error){
                alert(result.message);
                return;
            }

            /* MemberListResponse(list, page, pageSize 등등) */
            return result;
        }

        //리스트 새로고침
        async function refreshList(page = null){

            if(page !== null){
                //현재 페이지 저장
                currentPage = page;
            }

            const status = statusFilter.value;
            const role = roleFilter.value;
            const keyword = keywordInput.value.trim();

            const headerCheck = document.getElementById('checkAll');
            if (headerCheck) headerCheck.checked = false;

            try{
                const result = await getMemberList(currentPage, pageSize, status, role, keyword);
                if(!result) return ;
                renderTable(result.memberList);
                renderPagination(result.page, result.totalPage);
            } catch (err) {
                console.error(err);
                alert('네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.')
            }
        }

        //상태 변경 관련 함수----------------------------------------------------------------------------------------------

        //전체 체크박스 선택하는 로직
        function handleSelectAll() {
            const headerCheck = document.getElementById('checkAll');
            const checkboxes = document.getElementsByName('check-member');
            const enabledCheckboxes = Array.from(checkboxes).filter(chk => !chk.disabled);
            for (let i = 0; i < enabledCheckboxes.length; i++) {
                const row = enabledCheckboxes[i].closest('tr')
                enabledCheckboxes[i].checked = headerCheck.checked;
                if(headerCheck.checked){
                    row.classList.add('selected-row');
                } else {
                    row.classList.remove('selected-row');
                }
            }
        }

        //선택된 행 배경 색상 변경
        document.addEventListener('change', function(e) {
            if(e.target.name === 'check-member') { //name : check-member
                const row = e.target.closest('tr');

                if(e.target.checked){
                    row.classList.add('selected-row');
                } else {
                    row.classList.remove('selected-row');
                }
            }
        });

        //모달 띄우고 이유 받기
        function openReasonModal(){
            return new Promise((resolve) => {
                const reasonModalEl = document.getElementById('reasonModal');
                const reasonInputEl = document.getElementById('reasonInput');
                const confirmBtn = document.getElementById('reason-confirm');

                const reasonModal = bootstrap.Modal.getOrCreateInstance(reasonModalEl);

                let confirmed = false;   // 모달 확인 버튼을 눌렀는지 여부

                //인풋 초기화
                reasonInputEl.value = '';

                //열릴때 인풋에 포커스
                reasonModalEl.addEventListener(
                    'shown.bs.modal',
                    ()=> reasonInputEl.focus(),
                    { once: true }
                );

                //모달 확인 버튼 클릭
                const onConfirm = () => {
                    const text = reasonInputEl.value.trim();
                    if(!text) {
                        alert('사유를 입력해주세요.');
                        reasonInputEl.focus();
                        return;
                    }
                    confirmed = true;
                    confirmBtn.blur();
                    reasonModal.hide(); // 모달 닫기
                    resolve(text); //입력 사유 반환
                };

                confirmBtn.addEventListener('click', onConfirm); //확인 버튼에 위에 함수 주입

                //모달 닫기 (확인 / 취소)
                reasonModalEl.addEventListener(
                    'hide.bs.modal',
                    () => {
                        //확인 버튼이 아니라면
                        if (!confirmed) {
                            resolve(null);   // 취소로 간주 - null 반환
                        }
                        //확인 버튼에 이벤트 정리
                        confirmBtn.removeEventListener('click', onConfirm);
                }, { once: true });

                reasonModal.show();
            });
        }

        //검증 + 사유 수집
        async function prepareStatusChange(status) {

            const checkedMember = document.querySelectorAll('input[name="check-member"]:checked');
            if(checkedMember.length === 0){
                alert('선택된 회원이 없습니다.')
                return;
            }

            const oldStatusList = Array.from(checkedMember).map(checkbox => {
                const tr = checkbox.closest('tr'); //에서 가장 가까운 tr
                const statusTd = tr.querySelector(".member-status"); //의 member-status td
                return statusTd ? statusTd.textContent.trim() : '';
            });

            //변경 안되는 상태 섞여있는 경우 막기
            for(let oldStatus of oldStatusList){
                if(isInvalidStatusChange(oldStatus, status)){
                    alert(oldStatus + " 상태인 회원이 포함되어 있어 " + translateStatus(status) +"(으)로 변경할 수 없습니다. 다시 선택해주세요.")
                    return;
                }
            }

            const confirmed = confirm(checkedMember.length + '명의 상태를 ' + translateStatus(status) + '(으)로 변경하시겠습니까?');
            if(!confirmed)  return;

            // 사유 필요 여부
            const needReason = oldStatusList.some(oldStatus => isReasonRequired(oldStatus, status));
            let reason = '';
            if (needReason){
                reason = await openReasonModal();
                if(reason === null) {
                    //모달에서 취소되서 reason값 없는 경우
                    return;
                }
            }

            // memberNo 배열
            const memberNoList = Array.from(checkedMember).map(checked => checked.value);
            return { memberNoList, reason };
        }

        //상태 업데이트 서버 통신
        async function updateStatus(status){
            const prepared = await prepareStatusChange(status);
            if(!prepared) return;

            try{
                const response = await fetch('/admin/api/updatestatus',{
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify({
                        memberList : prepared.memberNoList,
                        status: status,
                        reason: prepared.reason,
                    })
                });

                const result =  await response.json();

                if(result.error) {
                    alert(result.message);
                    return;
                }

                if (result.success){
                    const count = result.count;
                    const resultStatus = translateStatus(result.status);
                    alert(count + '명의 상태가 ' + resultStatus + '(으)로 변경되었습니다.');
                    await refreshList();
                } else {
                    alert('회원 상태 변경에 실패했습니다. 다시 시도해주세요.');
                }
            } catch (err){
                console.error(err);
                alert('네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
            }
        }


        //상태 변경 안되는 경우
        function isInvalidStatusChange(oldStatus, newStatus) {
            const rules = {
                "삭제" : ["ANY"], //삭제 -> x
                "탈퇴" : ["ANY"], //탈퇴 -> x
                "승인" : ["APPROVED"], // 승인 -> 승인 x
                "거절" : ["REJECTED", "APPROVED"] // 거절 -> 거절, 승인 x
                //"대기중" : 어떤 상태로든 변경 가능
            }
            const invalidTargets = rules[oldStatus] // ["ANY"] , ["APPROVED"] 등등 값
            if(!invalidTargets) return false; // invalidTargets 비어있으면 false : 대기중

            //[]에 ANY가 들어있으면 true || []에 newStatus값이 들어있으면 true
            return invalidTargets.includes("ANY") || invalidTargets.includes(newStatus);
        }

        //변경 이유 필요한 경우
        function isReasonRequired(oldStatus, newStatus) {
            const rules = {
                "대기중": ["REJECTED", "DELETED"], //대기중 -> 거절, 삭제 사유 필요
                "승인": ["DELETED", "REJECTED"], //승인 -> 거절, 삭제 사유 필요
                "거절": ["DELETED"] //거절 -> 삭제 사유 필요
                //탈퇴, 삭제 : 변경 불가
            }

            const requiredTargets = rules[oldStatus];
            if (!requiredTargets) return false;

            return requiredTargets.includes(newStatus);
        }

        //회원 상세보기 모달 ----------------------------------------------------------------------------------------------
        let selectedMemberNo = null;
        let selectedMemberName = null;
        let selectedMemberStatus = null;
        let oldRole = null;
        let roleChanged = false;
        let memberDetailModal = null;

        document.addEventListener('DOMContentLoaded', () => {
            // 모달 엘리먼트 & 인스턴스 생성
            const modalEl = document.getElementById('memberDetailModal');
            memberDetailModal = bootstrap.Modal.getOrCreateInstance(modalEl);

            // 권한 셀렉트 변경 감지
            const roleSelect = document.getElementById('modal-memberRole-select');
            roleSelect.addEventListener('change', () => {
                roleChanged = true;
            });

            // 모달이 완전히 닫힐 때 상태 초기화 (선택 사항이지만 깔끔해서 넣음)
            modalEl.addEventListener('hidden.bs.modal', () => {
                roleChanged = false;
                selectedMemberNo = null;
                selectedMemberName = null;
                selectedMemberStatus = null;
                oldRole = null;
            });
        });

        //상세 정보 모달
        async function openMemberDetailModal(memberNo) {
            roleChanged = false;
            try {
                const response = await fetch('/admin/api/memberDetail?memberNo=' + memberNo)

                const result = await response.json();

                if(result.error) {
                    roleChanged = false;
                    alert(result.message);
                    return;
                }

                if(result.success) {

                    const {member} = result;

                    document.getElementById('modal-name').innerHTML = member.name;
                    document.getElementById('modal-memberId').innerHTML = member.memberId;
                    document.getElementById('modal-gender').innerHTML = translateGender(member.gender);
                    document.getElementById('modal-age').innerHTML = member.age;
                    document.getElementById('modal-address').innerHTML = '[' + member.zipCode + '] ' + '<br>' + member.addressBase + '<br>' + (member.addressDetail ?? "");
                    document.getElementById('modal-email').innerHTML = member.email;
                    document.getElementById('modal-phone').innerHTML = member.phone;
                    document.getElementById('modal-createdDate').innerHTML = formatDate(member.createdDate);
                    const modalRoleSelect = document.getElementById('modal-memberRole-select');
                    modalRoleSelect.value = member.memberRole;
                    document.getElementById('modal-memberStatus').innerHTML = translateStatusBadge(member.memberStatus);
                    document.getElementById('modal-statusReason').innerHTML = member.changedReason ?? "-";
                    document.getElementById('modal-changedDate').innerHTML = formatDate(member.changedDate);

                    memberDetailModal.show();

                    selectedMemberNo = memberNo;
                    selectedMemberName = member.name;
                    selectedMemberStatus = member.memberStatus;
                    oldRole = member.memberRole;
                }

            } catch (error) {
                roleChanged = false;
                console.error("error : " + error);
                alert('네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.')
            }
        }

        //권한 변경
        async function editRoleByAdmin() {

            const memberNo = Number(selectedMemberNo);

            if(!roleChanged){
                memberDetailModal.hide();
                return;
            }

            if(!memberNo) {
                alert("회원 정보가 확인되지 않습니다. 창을 닫고 다시 시도해주세요.");
                roleChanged = false;
                return;
            }

            if(selectedMemberStatus !== 'APPROVED') {
                alert("회원을 먼저 승인 후 권한 변경을 요청하여주세요.");
                roleChanged = false;
                return;
            }

            const newRole = document.getElementById('modal-memberRole-select').value.trim();
            if(newRole === oldRole){
                alert("현재 회원은 이미 해당 권한을 가지고 있습니다.");
                roleChanged = false;
                return;
            }

            const confirmed = confirm(selectedMemberName + "님을 \"" + translateRole(newRole) + "\"(으)로 변경하시겠습니까?");
            if(!confirmed) return;

            try {
                const url = "/admin/api/updateRole/" + memberNo + "/role";

                const response = await fetch(url, {
                    method: "PATCH",
                    headers: { "Content-Type" : "application/json" },
                    body: JSON.stringify({ role: newRole })
                });

                const result = await response.json();

                if(result.error){
                    alert(result.message);
                    return;
                }

                if (result.success) {
                    await refreshList();
                    alert('권한 변경이 완료되었습니다.');
                    roleChanged = false;
                    memberDetailModal.hide();
                } else {
                    alert('권한 변경에 실패했습니다. 다시 시도해주세요.');
                }
            } catch (error) {
                console.error(error);
                alert('네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
            }
        }


        //뷰 헬퍼---------------------------------------------------------------------------------------------------------
        //본인 계정 선택 막기
        function disableMyCheckbox() {
            const checkboxes = document.getElementsByName("check-member");
            Array.from(checkboxes).forEach(check => {
                const memberNo = Number(check.value);
                if (memberNo === loginMemberNo) {
                    check.disabled = true;
                }
            });
        }
        //상세보기 아이콘에 클릭이벤트 넣기
        function setShowDetail() {
            const infoIcons = document.querySelectorAll(".fa-circle-info");
            infoIcons.forEach(i => {
                i.addEventListener("click", () => {
                    const tr = i.closest("tr");
                    const checkbox = tr.querySelector("input[name='check-member']");
                    const memberNo = checkbox ? checkbox.value : null;
                    openMemberDetailModal(memberNo);
                })
            })
        }

        //유틸 함수-------------------------------------------------------------------------------------------------------
        //권한 값 영어 -> 한국어
        function translateRole(role){
            if(!role) return '-';
            const roleMap = {
                ADMIN: '관리자',
                MEMBER: '일반 회원'
            }
            return roleMap[role?.toUpperCase()] || '-';
        }

        //상태 값 영어 -> 한국어
        function translateStatus(status){
            if (!status) return '-';
            const statusMap = {
                PENDING : '대기중',
                APPROVED : '승인',
                REJECTED : '거절',
                DELETED : '삭제',
                WITHDRAWN : '탈퇴'
            }
            return statusMap[status.toUpperCase()] || '-';
        }

        //상태 값 뱃지
        function translateStatusBadge(status) {
            if(!status) return `<span class="badge bg-light text-dark">-</span>`;
            switch (status) {
                case 'PENDING':   return `<span class="badge bg-warning text-dark">대기중</span>`;
                case 'APPROVED':  return `<span class="badge bg-success">승인</span>`;
                case 'REJECTED':  return `<span class="badge bg-danger">거절</span>`;
                case 'DELETED':   return `<span class="badge bg-dark">삭제</span>`;
                case 'WITHDRAWN': return `<span class="badge bg-dark">탈퇴</span>`;
            }
        }

        //성별 값 영어 -> 한국어
        function translateGender(gender){
            if(!gender) return '-';
            const genderMap = {
                M: '남성',
                W: '여성'
            }
            return genderMap[gender?.toUpperCase()] || '-';
        }

        //날짜변환
        function formatDate(rawdate) {
            if (!rawdate) return "-";

            const date = new Date(rawdate); // ← 이게 이미 정상

            if (isNaN(date.getTime())) return "-";

            const yyyy = date.getFullYear();
            const mm = String(date.getMonth() + 1).padStart(2, "0");
            const dd = String(date.getDate()).padStart(2, "0");

            return yyyy + '/' + mm + '/' + dd;
        }
    </script>
</head>

<body>
<!-- 공통 헤더 -->
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<h1 class="title">회원 목록</h1>
<div class="table-wrap" id="outer">
    <div id="tool-div">
        <div id="button-div">
            <button type="button" class="btn btn-outline-success btn-sm" onclick="updateStatus('APPROVED')">승인</button>
            <button type="button" class="btn btn-outline-danger btn-sm" onclick="updateStatus('REJECTED')">거절</button>
            <button type="button" class="btn btn-outline-dark btn-sm" onclick="updateStatus('DELETED')">삭제</button>
        </div>
        <div id="search-div">
            <input type="text" id="keyword-input" placeholder="아이디/이메일/주소">
            <button type="button" class="btn btn-primary btn-sm" id="search-btn">검색</button>
        </div>
    </div>

        <table class="member-table">
            <!-- 🔒 열 폭 고정 -->
            <colgroup>
                <col style="width:5%">   <!-- 선택 -->
                <col style="width:4%">   <!-- 번호 -->
                <col style="width:7%">   <!-- 이름 -->
                <col style="width:7%">   <!-- 아이디 -->
                <col style="width:9%">   <!-- 비밀번호 -->
                <col style="width:4%">   <!-- 성별 -->
                <col style="width:4%">   <!-- 나이 -->
                <col style="width:23%">  <!-- 주소 -->
                <col style="width:9%">   <!-- 연락처 -->
                <col style="width:14%">  <!-- 이메일 -->
                <col style="width:7%">   <!-- 회원 구분 -->
                <col style="width:7%">   <!-- 회원 상태 -->
                <col style="width:4%">   <!-- 상세보기 -->
            </colgroup>
            <thead>
            <tr>
                <th>
                    <input type="checkbox" id="checkAll" onchange="handleSelectAll()">
                    선택
                </th>
                <th>번호</th>
                <th>이름</th>
                <th>아이디</th>
                <th>비밀번호</th>
                <th>성별</th>
                <th>나이</th>
                <th>주소</th>
                <th>연락처</th>
                <th>이메일</th>
                <th>회원 구분<br/>
                    <select id="role-filter">
                        <option value="">전체</option>
                        <option value="ADMIN">관리자</option>
                        <option value="MEMBER">일반 회원</option>
                    </select>
                </th>
                <th>회원 상태 <br/>
                    <select id="status-filter">
                        <option value="">전체</option>
                        <option value="PENDING">대기중</option>
                        <option value="APPROVED">승인</option>
                        <option value="REJECTED">거절</option>
                        <option value="DELETED">삭제</option>
                        <option value="WITHDRAWN">탈퇴</option>
                    </select>
                </th>
                <th>상세</th>
            </tr>
            </thead>
            <tbody id="member-tbody">
            <%-- renderTable가 여기를 채움 --%>
            </tbody>
        </table>

    <%--페이징 바--%>
    <nav aria-label="Page navigation example" style="display:flex; justify-content:center; margin-top:20px;">
        <ul class="pagination">
            <%--renderPagination--%>
        </ul>
    </nav>
</div>

<%--사유 작성 모달--%>
<div class="modal fade" id="reasonModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content verify-modal">

            <div class="modal-header">
                <h5 class="modal-title" id="reason-modal-title">사유 입력</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">
                    <textarea id="reasonInput" class="form-control" rows="4" maxlength="100"
                              placeholder="처리 사유를 입력해주세요 (최대 100자)"></textarea>
            </div>

            <div class="modal-footer justify-content-center">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" id="reason-confirm">확인</button>
            </div>

        </div>
    </div>
</div>


<%--회원 상세 정보 모달--%>
<div class="modal fade" id="memberDetailModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content verify-modal">

            <div class="modal-header">
                <h5 class="modal-title" id="detail-modal-title">회원 상세 정보</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">
                <table>
                    <tr>
                        <th>이름</th>
                        <td id="modal-name"></td>
                    </tr>
                    <tr>
                        <th>아이디</th>
                        <td id="modal-memberId"></td>
                    </tr>
                    <tr>
                        <th>성별</th>
                        <td id="modal-gender"></td>
                    </tr>
                    <tr>
                        <th>나이</th>
                        <td id="modal-age"></td>
                    </tr>
                    <tr>
                        <th>주소</th>
                        <td id="modal-address"></td>
                    </tr>
                    <tr>
                        <th>이메일</th>
                        <td id="modal-email"></td>
                    </tr>
                    <tr>
                        <th>전화번호</th>
                        <td id="modal-phone"></td>
                    </tr>
                    <tr>
                        <th>가입일</th>
                        <td id="modal-createdDate"></td>
                    </tr>
                    <tr>
                        <th>회원 구분</th>
                        <td id="modal-memberRole">
                            <select id="modal-memberRole-select">
                                <option value="MEMBER">일반회원</option>
                                <option value="ADMIN">관리자</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th>회원 상태</th>
                        <td id="modal-memberStatus"></td>
                    </tr>
                    <tr>
                        <th>상태 이유</th>
                        <td id="modal-statusReason"></td>
                    </tr>
                    <tr>
                        <th>상태 변경 날짜</th>
                        <td id="modal-changedDate"></td>
                    </tr>
                </table>
            </div>

            <div class="modal-footer justify-content-center">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" id="confirm" onclick="editRoleByAdmin()">확인</button>
            </div>

        </div>
    </div>
</div>




<%-- 부트스트랩 js --%>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI" crossorigin="anonymous"></script>

</body>
</html>
