<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../include/include.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>AbleSky代码发布系统</title>
<%@ include file="../../include/includeCss.jsp" %>
<style>
.title {
	text-align: center;
	font-family: 微软雅黑;
}
.list-wrapper {
	width: 800px; margin: 10px auto 20px;
}
.list-wrapper {
	margin-top: 30px;
}
.list-wrapper .table {
	width: 100%;
}
.list-wrapper th, .list-wrapper td {
	text-align: center;
}
.create-btn-wrapper {
	text-align: center;
	margin: 10px auto 20px;
}
.create-btn-wrapper .btn {
	width: 80px;
}
</style>
</head>
<body>
<%@ include file="../../include/header.jsp" %>

<div class="wrapper">
	<h2 class="title">用户列表</h2>
	<div class="list-wrapper">
		<table class="table table-bordered table-condensed table-hover">
			<thead>
				<tr>
					<th style="width: 50px;">id</th>
					<th style="width: 200px;">用户名</th>
					<th style="width: 300px;">注册日期</th>
					<th style="width: 100px;">超级管理员</th>
					<th style="width: 150px;">操作</th>
				</tr>
			</thead>
			<tbody id="J_tbody">
				<c:forEach items="${list}" var="user">
					<c:set var="isSuperAdmin" value="${superAdminMap[user.username] != null}"></c:set>
					<tr>
						<td>${user.id}</td>
						<td>${user.username}</td>
						<td><fmt:formatDate value="${user.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
						<td><input class="superadmin-switch-cbx" data-id="${user.id}" type="checkbox" <c:if test="${isSuperAdmin == true}">checked="checked"</c:if> /></td>
						<td>
							<a class="edit-btn" href="javascript:void(0);" data-id="${user.id}">修改密码</a>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
</div>
</body>
<%@ include file="../../include/includeJs.jsp" %>
<script>
seajs.use('app/admin/user/list', function(list){
	list.init();
});
</script>
</html>