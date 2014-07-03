<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/include.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>AbleSky代码发布系统</title>
<%@ include file="../include/includeCss.jsp" %>
<link rel="stylesheet" href="${ctx_path}/css/bootstrapSwitch.css" />
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
<%@ include file="../include/header.jsp" %>

<div class="wrapper">
	<h2 class="title">项目列表</h2>
	<div class="list-wrapper">
		<div class="create-btn-wrapper">
			<button id="J_createBtn" class="btn btn-inverse">新&nbsp;&nbsp;增</button>
		</div>
		<table class="table table-bordered table-condensed table-hover">
			<thead>
				<tr>
					<th style="width: 50px;">id</th>
					<th style="width: 250px;">项目名称</th>
					<th style="width: 250px;">包名称</th>
					<th style="width: 100px;">脚本类型</th>
					<th style="width: 150px;">操作</th>
				</tr>
			</thead>
			<tbody id="J_tbody">
				<c:forEach items="${list}" var="project">
					<tr>
						<td>${project.id}</td>
						<td>${project.name}</td>
						<td>${project.warName}</td>
						<td>
							<div class="switch switch-mini" data-id="${project.id}" data-on-label="新" data-off-label="旧">
    							<input type="checkbox" <c:if test="${project.deployScriptType > 0 }">checked</c:if>/>
							</div>
						</td>
						<td>
							<a class="edit-btn" href="javascript:void(0);" data-id="${project.id}">修改</a>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
</div>
</body>
<%@ include file="../include/includeJs.jsp" %>
<script type="text/javascript" src="${ctx_path}/js/bootstrap/bootstrapSwitch.js"></script>
<script>
$(function(){
	initCreateProjectBtn();
	initDeleteProjectBtn();
	initUpdateProjectBtn();
	initDeployScriptTypeSwitch();
});

function initCreateProjectBtn() {
	$('#J_createBtn').on('click', function(){
		openEditProjectWin({
			width: 420, 
			height: 240,
			url: CTX_PATH + '/project/edit'
		});
	});
}

function initUpdateProjectBtn() {
	$('#J_tbody').on('click', 'a.edit-btn', function(){
		var $this = $(this),
			id = $this.attr('data-id');
			openEditProjectWin({
				width: 420, 
				height: 280,
				url: CTX_PATH + '/project/edit/' + id
			});
	});
}

function openEditProjectWin(options) {
	options = options || {};
	var width = options.width || 420,
		height = options.height || 300;
	var screenWidth = window.screen.availWidth,
		screenHeight = window.screen.availHeight,
		left = (screenWidth - width) / 2,
		top = (screenHeight - height) / 2;
	var winConfig = [
		'width=' + width,
		'height=' + height,
		'left=' + left,
		'top=' + top
	].join(',');
	var url = options.url;
	window.open(url, '_blank', winConfig);
}

function initDeleteProjectBtn() {
	$('#J_tbody').on('click', 'a.delete-btn', function(){
		var $this = $(this);
		$.post(CTX_PATH + '/project/delete/' + $this.attr('data-id'), function(data){
			alertMsg(data.message).done(function(){
				if(data.success === true) {
					location.reload();
				}
			});
		});
	});
}

function initDeployScriptTypeSwitch() {
	var states = {};
	$('#J_tbody').on('switch-change', '.switch', function(e, data){
		var $this = $(this),
			prevValue = !data.value,
			projectId = $this.attr('data-id');
		if(states[projectId]) {	// 正在请求中
			return;
		}
		states[projectId] = true;
		var deployScriptType = data.value? 1: 0;	// 1 means the new script while 0 means the old one
		$.ajax({
			url: CTX_PATH + '/project/switch/' + projectId,
			type: 'POST',
			data: {deployScriptType: deployScriptType}
		}).done(function(){
			if(data.deployScriptType !== deployScriptType) {
				$this.bootstrapSwitch('setState', data.deployScriptType); 
			}
		}).fail(function(){
			$this.bootstrapSwitch('setState', prevValue); 
		}).always(function(){
			states[projectId] = false;
		});
	});
}

function reloadPage() {
	location.reload();
}
</script>
</html>