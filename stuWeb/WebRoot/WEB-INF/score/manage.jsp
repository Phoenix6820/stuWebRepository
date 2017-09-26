<%@page import="util.Pagination"%>
<%@ page language="java" import="java.util.*,entity.*"
	pageEncoding="utf-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">

<title>My JSP 'list.jsp' starting page</title>

<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">

<link rel="stylesheet" type="text/css"
	href="bootstrap/css/bootstrap.min.css">
<style>
#main {
	width: 800px;
	margin: 10px auto;
}

#mes {
	float: right;
	width: 150px;
	height: 36px;
	line-height: 30px;
	letter-spacing: 3px;
	color: red;
}

.fenye {
	float: right;
	margin: 0;
	padding: 0;
	margin: 0;
}

.fenye li {
	list-style: none;
	float: left;
	padding: 6px 12px;
	font-size: 14px;
	line-height: 140%;
	border: 1px solid #ddd;
	text-align: center;
	color: #337ab7;
	margin-left: -1px;
}

.fenye li:hover {
	background: #eee;
	cursor: pointer;
}

.fenye li:first-child {
	border-top-left-radius: 4px;
	border-bottom-left-radius: 4px;
}

.fenye li:last-child {
	border-top-right-radius: 4px;
	border-bottom-right-radius: 4px;
}

.fenye .active {
	color: #fff;
	background-color: #337ab7;
	border-color: #337ab7;
}

.fenye .active:hover {
	color: #fff;
	background-color: #337ab7;
	border-color: #337ab7;
}

.selected {
	background: #337ab7
}

.btn-group {
	margin-top: 50px;
}

#search {
	overflow: hidden;
	margin-bottom: 20px;
}

#search label {
	float: left;
	margin-right: 10px;
	height: 30px;
	line-height: 30px;
}

#search  #searchBtn {
	
}

#search .value {
	width: 120px;
	height: 30px;
	float: left;
	margin-right: 20px;
}

.score {
	width: 80px;
}
</style>
<script type="text/javascript" src="js/jquery.js"></script>

<script>
	$(document).ready(
			function() {

				var ye = ${p.ye};
				var maxYe = ${p.maxYe};
				function clickYeMa(selectYe) {

					var stuName = $("#stuName").val();
					var bj = $("#bj").val();
					var sub = $("#sub").val();
					location.href = "sc?type=manage&ye=" + selectYe

					+ "&stuName=" + stuName + "&bj=" + bj + "&sub=" + sub;

				}

				$("#shou").click(function() {
					clickYeMa(1);
				})

				$("#wei").click(function() {
					clickYeMa(maxYe);
				})

				$("#pre").click(function() {
					if (ye > 1) {
						clickYeMa(ye - 1)
					} else {
						showMes("已经是第一页了");
					}
				})
				$("#next").click(function() {
					if (ye < maxYe) {
						clickYeMa(ye + 1);
					} else {
						showMes("已经是最后一页了");
					}
				})

				$("[ name=numPage]").click(function() {
					clickYeMa($(this).html());
				})

				function showMes(mes) {
					$("#mes").html(mes);
					setTimeout(function() {
						$("#mes").html("");
					}, 1000);
				}

				$("tbody tr").click(function() {
					$(this).toggleClass("selected");

				})
				$("#bj").change(
						function() {
							$.ajax({
								url : "sub?type=searchSubByBj",
								data : {
									bjId : $(this).val()
								},
								type : "post",
								dataType : "json",
								success : function(data) {
									var ops = "";
									$.each(data, function(index, element) {
										ops += "<option value="+element.id+">"
												+ element.name + "</option>";

									})
									$("#sub").html(ops);
								}
							})
						})
				var score = 0;
				$(".score").focus(function() {
					score = $(this).val();
				})
				$(".score").blur(
						function() {
							if ($(this).val() != score) {
								var scId = $(this).parent().parent().attr(
										"score");
								var stuId = $(this).parent().siblings(
										"[name=stu]").data("id");
								var subId = $(this).parent().siblings(
										"[name=sub]").data("id");
								var txt = $(this);
								$.ajax({
									url : "sc?type=input",
									data : {
										scId : scId,
										stuId : stuId,
										subId : subId,
										score : $(this).val()
									},
									type : "post",
									dataType : "text",
									success : function(data) {
										if (data != "false") {
											showMes("保存成功！");
											var json = JSON.parse(data);
											txt.parent().siblings(
													"[name=grade]").html(
													json.grade);
											txt.parent().parent().attr("score",
													json.id)
										} else {

											showMes("保存失败！");

										}
									}

								})
							}

						})
			})
</script>
</head>

<body>
	<div id="main">
		<div id="search">
			<form action="sc" method="post">
				<input type="hidden" name="type" value="search" /> <label>姓名</label>
				<input type="text" id="stuName" name="stuName"
					class="form-control value" value="${condition.stu.name}" /> <label>班级</label>
				<select id="bj" name="bj" class="form-control value"><option
						value="0">请选择班级</option>
					<c:forEach items="${bjs}" var="bj">
						<option value="${bj.id}"
							<c:if test="${condition.stu.bj.id==bj.id }">selected</c:if>>${bj.name}</option>
					</c:forEach>
				</select> <label>科目</label> <select id="sub" name="sub"
					class="form-control value"><option value="0">请选择科目</option>
					<c:forEach items="${subs}" var="sub">
						<option value="${sub.id}"
							<c:if test="${condition.sub.id==sub.id }">selected</c:if>>${sub.name}</option>
					</c:forEach>
				</select> <input id="searchBtn" type="submit" value="查找"
					class="btn btn-primary" />




			</form>
		</div>
		<table class="table table-bordered">
			<thead>
				<tr>
					<th>姓名</th>
					<th>班级名</th>
					<th>科目名</th>
					<th>等级</th>
					<th>成绩</th>

				</tr>
			</thead>
			<tbody>
				<c:forEach var="sc" items="${scs}">
					<tr score="${sc.id }">
						<td>${sc.stu.name}</td>
						<td data-id="${sc.stu.id}" name="stu">${sc.stu.bj.name}</td>
						<td data-id="${sc.sub.id}" name="sub">${sc.sub.name}</td>
						<td name="grade">${sc.grade}</td>
						<td><input class="score"
							<c:choose>
						<c:when test="${sc.score!=null }">
						value="${sc.score }"
						</c:when>
						<c:otherwise>
						placeholder="未录入"
						</c:otherwise>
						</c:choose> />
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		<ul class="fenye">
			<li id="shou">首页</li>
			<li id="pre">上一页</li>
			<c:forEach begin="${p.begin}" end="${p.end}" varStatus="status">
				<li name="numPage"
					<c:if test="${p.ye==status.index}"> class="active"</c:if>>${status.index }</li>
			</c:forEach>
			<li id="next">下一页</li>
			<li id="wei">尾页</li>
		</ul>
		<div id="mes"></div>



	</div>

</body>
</html>
