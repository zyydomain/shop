<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();

%>
<script type="text/javascript">
 $(function(){
		//大区级联--控制省
		$("select[id='bigAreaDB']").change(function(){
			 //被选中的option  
              var selected_value =$(this).val();
			 if(selected_value == ""){
				 $("select[id='provinceListDB']").empty();
				 $("#provinceListDB").prepend("<option value=''>--全部--</option>"); 
				 $("select[id='cityListDB']").empty();
				 $("#cityListDB").prepend("<option value=''>--全部--</option>");
			 }else{
				 $("select[id='provinceListDB']").empty();
				 $("#provinceListDB").prepend("<option value=''>--全部--</option>"); 
				 $("select[id='cityListDB']").empty();
				 $("#cityListDB").prepend("<option value=''>--全部--</option>");
				 $.ajax({
		           type:"get",
		               //  dataType:"json",
		             contentType:"application/json;charset=utf-8",
		             url:"ditch/getProvinceByArea?areaId="+selected_value,
		                 success:function(result){
						 var obj = eval( '('+ result + ')' ); 
		                     $.each(obj,function(index,value){
								$("#provinceListDB").append("<option value='"+value.id+"'>"+value.provinceName+"</option>");
		                     })   
						    $("#provinceListDB option[value="+"${city.parProvince}"+"]").attr("selected","selected");
		                 },
		                 error : function(XMLHttpRequest, textStatus, errorThrown) {
		                     alert(errorThrown);
		             },
		                 async:false             //false表示同步
                  });	
			 } 
		})
		
	   //省级联-控制市
       $("select[id='provinceListDB']").change(function() {
			 //被选中的option  
			 var selected_value = $(this).val(); 
			 if(selected_value == ""){  
				 $("select[id='cityListDB']").empty();
			     $("#cityListDB").prepend("<option value=''>--全部--</option>");
			 }else{
				 $("select[id='cityListDB']").empty();
				 $("#cityListDB").prepend("<option value=''>--全部--</option>");
				 $.ajax({
		                 type:"get",
		               //  dataType:"json",
		                 contentType:"application/json;charset=utf-8",
		                 url:"ditch/getCityByProvince?areaId="+selected_value,
		                 success:function(result){
						 var obj = eval( '('+ result + ')' );
						 $.each(obj,function(index,value){
						 $("#cityListDB").append("<option value='"+value.id+"'>"+value.cityName+"</option>");
			               })
		                 $("#cityListDB option[value="+"${db.parCity}"+"]").attr("selected","selected"); 
		                 },
		                 error : function(XMLHttpRequest, textStatus, errorThrown) {
		                     alert(errorThrown);
		             },
		                 async:false             //false表示同步
                  });	
			 } 
		})
		
		$("select[id='bigAreaDB']").change();
		$("select[id='provinceListDB']").change();

});
</script>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=7" />
		<title>添加BD</title>
	</head>
	<body>
		<div class="pageContent">
			<form method="post" action="ditch/saveDB"  id="formc"
				onsubmit="return validateCallback(this, navTabAjaxDone);" class="pageForm required-validate">
				
				<div class="pageFormContent" layoutH="56">
				    <p>
						<label>大区:</label>
						<select name="parBigArea" class="required" id="bigAreaDB"
						<c:if test="${not empty role && role >=10021}">disabled="disabled"</c:if>>
						<option value="" >--全部--</option>
						<c:forEach items="${bigAreaList}" var="bigAreaList">
							<option value="${bigAreaList.id }" 
							<c:if test="${bigAreaList.id  eq bidArea.id}">selected="selected"</c:if>>${bigAreaList.bigAreaName }</option>
						</c:forEach>
					</select>
						
					</p>
				 <div class="divider"></div>
				     <p>
						<label>省:</label>
						<select name="parProvince" class="required" id="provinceListDB"
						<c:if test="${not empty role && role >=10022}">disabled="disabled"</c:if>>
				     	</select>
						
					</p>
				  <div class="divider"></div>
				       <p>
						<label>市:</label>
						<select name="parCity" class="required" id="cityListDB"
						<c:if test="${not empty role && role >=10023}">disabled="disabled"</c:if>>
				     	</select>
						
					</p>
				  <div class="divider"></div>
					<p>
						<label>BD名称:</label>
						<input name="dbName" class="required" type="text" alt="请输入BD名称" 
						value="${db.dbName }" />
					</p>
					<input type="hidden" value="${db.id }" name="id"/>
				 <div class="divider"></div>
				</div>
				<div class="formBar">
					<ul>
						<li>
							<div class="buttonActive">
								<div class="buttonContent">
									<button type="button" onclick="sub();">
										保存
									</button>
								</div>
							</div>
						</li>
						<li>
							<div class="button">
								<div class="buttonContent">
									<button type="button" class="close">
										取消
									</button>
								</div>
							</div>
						</li>
					</ul>
				</div>
			</form>
		</div>
	</body>
	<script type="text/javascript">
	  function sub(){
		  $("select[name='parBigArea']").removeAttr("disabled"); 
		  $("select[name='parProvince']").removeAttr("disabled"); 
		  $("select[name='parCity']").removeAttr("disabled"); 
		  $("#formc").submit();
	  }
	</script>
	
</html>
