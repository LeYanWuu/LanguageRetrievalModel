<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>LangugeModel</title>
<link rel="stylesheet" type="text/css"
	href="css/bootstrap-theme.min.css">
<link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
<script src="jquery-2.1.1/jquery.min.js" type="text/javascript"></script>
<script src="js/bootstrap.min.js" type="text/javascript"></script>


<script type="text/javascript">
$(document).ready(function () {  //获取文件名，添加分词/去标点的下拉选项
	$.ajax({
		type:"POST",
		url:"getFileNames",
		traditional: true,
		datatype:"json",
		contentType:"application/x-www-form-urlencoded; charset=utf-8",
		success:function(fileNames){
			fileNames = JSON.parse(fileNames);
			alert(fileNames);
			$.each(fileNames, function(index, name) {
				//alert(index+": "+name);
				$('#dropdown1').append("<li class='down' id='"+name+"' name='down1' role='presentation'><a href='#'>"+name+"</a></li>");
				$('#dropdown2').append("<li class='down' id='"+name+"' name='down2' role='presentation'><a href='#'>"+name+"</a></li>");
				});
			},
			error : function() {
				alert("文件名获取出错！");
			}

		});
	});
</script>	

<script type="text/javascript">
$(function() {
	//检索 button
	$("#search").click(function() {
		//var filePath = $("#filePath").val();//文档路径
		//alert(filePath);
		
		var query =""; //提交的检索词
		//var operators = new Array();//提交的逻辑运算符
		var boolExpr = "";//提交的检索表达式（以上两者构成） 
		
		var query = document.getElementsByID("expression").value;
		var select_arr = document.getElementsByName("operator");
		
	//	for(i=0;i<input_arr.length;i++){
	//		var term = input_arr[i].value;
	//		if(""!=term){
	//			//alert(term);
	//			terms[i]= term;
	//		}
	//	}
	//	for(i=0;i<terms.length-1;i++){
	//		var x = select_arr[i];
	//		operators[i] =x.options[x.selectedIndex].value;
	//		//alert(operators[i]);
	//		boolExpr += terms[i]+operators[i];
	//	}
		boolExpr = query;
		
		
		if(0 == query){ //没有检索词不能提交
			alert("请输入检索词！");
			$("#results").text("");// 清空数据
			$("#contents").empty();
			$("#invertedIndex").removeAttr("class");
			$("#segments").removeAttr("class");
			$("#noPun").removeAttr("class");
			$("#boolResults").attr("class","active");
			return;
		}
		if(input_arr[0].value==""){ //第一个检索词为空不能提交
			alert("第一个检索词不能为空！");
			$("#results").text("");// 清空数据
			$("#contents").empty();
			$("#invertedIndex").removeAttr("class");
			$("#segments").removeAttr("class");
			$("#noPun").removeAttr("class");
			$("#boolResults").attr("class","active");
			return;
		}
		$("# boolExpr").text("您检索的内容为："+boolExpr);
		$.ajax({
			type:"POST",
			url:"boolRetrival",
			data:{"query":query},
			traditional: true,
			datatype:"json",
			contentType:"application/x-www-form-urlencoded; charset=utf-8",
			success:function(JSONdata){
				//alert(JSONdata);
				if(0==JSONdata){
					alert("抱歉！没有满足条件的检索结果！");
					$("#results").text("");// 清空数据
					$("#contents").empty();
					$("#invertedIndex").removeAttr("class");
					$("#segments").removeAttr("class");
					$("#noPun").removeAttr("class");
					$("#boolResults").attr("class","active");
				}else{
					$("#results").text("");// 清空数据
					$("#contents").empty();
					$("#invertedIndex").removeAttr("class");
					$("#segments").removeAttr("class");
					$("#noPun").removeAttr("class");
					$("#boolResults").attr("class","active");
					JSONresults = JSON.parse(JSONdata);
					$.each(JSONresults,function(index,obj) {
						for (key in obj){ //解析出得到的文档名key 和原文contents
							var contents = obj[key];
							//alert(key+"-->"+contents);
							//$('#results4').append("<a href='' onclick="+viewContents(contents)+">"+key+"</a>");
							//$('#results4').append("<a href='#' class='ra'>"+key+"</a>");
							//$('#results4').append("<br>");
							$('#results').append("<a id='"+key+"' href='#' class='ra' style='color:white; font-size: 18px'>"+key+"</a>");
							$('#results').append("<br>");
							}
						}); 
				}
				
			},
			error:function(){
				alert("检索出错！");
				$("#results").text("");// 清空数据
				$("#contents").empty();
				$("#invertedIndex").removeAttr("class");
				$("#segments").removeAttr("class");
				$("#noPun").removeAttr("class");
				$("#boolResults").attr("class","active");
			}
			
		});
	});
});

 $(function() {//检索 a
	$("#boolResults").click(function() {
		document.getElementById('search').click();

	});
}); 

$(function() {//倒排索引
	$("#invertedIndex").click(function() {
		//alert("倒排索引");
		$.ajax({
			type:"POST",
			url:"buildIndex",
			traditional: true,
			datatype:"text",
			contentType:"application/x-www-form-urlencoded; charset=utf-8",
			success:function(invertedIndex){
			//	alert("索引成功返回！");
				//invertedIndex = JSON.parse(invertedIndex);
			//	alert(invertedIndex);
				$('#results').text("");// 清空数据
				$("#contents").empty();
				$("#boolResults").removeAttr("class");
				$("#segments").removeAttr("class");
				$("#noPun").removeAttr("class");
				$("#invertedIndex").attr("class","active");
				$('#results').append("<p style='color: rgb(255, 255, 255); font-size: 18px'></p>");
                $("p").append(invertedIndex);
               // $("p").append("<br>");
				//alert("索引建立成功！");
				
			},
			error:function(){
				alert("索引建立出错！");
				$("#results").text("");// 清空数据
				$("#contents").empty();
			}
		});

	});
});

</script>
<script type="text/javascript">

  $(function() {//这里是动态元素<a>添加的事件 查看文档的内容
	  $("body").on("click", ".ra", function() {
          //alert('这里是动态元素添加的事件');
          var fileName =$(this).attr("id");
          $(".ra").attr("style","font-size:18px; color:white");
          $(this).attr("style","font-size:20px; color:#C0C0C0");
  		//alert(fileName);
  		$.each(JSONresults,function(index,obj) {
			for (key in obj){
				//alert("key是："+key);
				var contents = obj[fileName];
				if(fileName==key){
					$("#contents").empty();
					$("#contents").html(fileName+": <br>"+contents);
				}
				}
			});  
      });
});  
 
$(function() {//这里是动态元素<li>添加的事件 分词结果
	  $("body").on("click", "li[name='down1']", function() {
       // alert('这里是动态元素下拉选项添加的事件');
        var fileName =$(this).attr("id");
		//alert(fileName);
		$.ajax({
			type:"POST",
			url:"segment",
			data:{"fileName":fileName},
			datatype:"text",
			contentType:"application/x-www-form-urlencoded; charset=utf-8",
			success:function(segments){
			//	alert("分词结果成功返回！");
			//	alert(segments);
				$('#results').text("");// 清空数据
				$("#contents").empty();
				$("#boolResults").removeAttr("class");
				$("#invertedIndex").removeAttr("class");
				$("#noPun").removeAttr("class");
				$("#segments").attr("class","active");
				$('#results').append("<p style='color: rgb(255, 255, 255); font-size: 18px'></p>");
				$("p").append(segments);
			//	alert("分词成功！");
				
			},
			error:function(){
				alert("分词出错！");
				$("#results").text("");// 清空数据
				$("#contents").empty();
			}
		});
    });
});  

$(function() {//这里是动态元素<li>添加的事件去标点结果
	$("body").on("click", "li[name='down2']", function() {
		var fileName =$(this).attr("id");
		//alert("去标点");
		$.ajax({
			type:"POST",
			url:"removePun",
			data:{"fileName":fileName},
			datatype:"text",
			contentType:"application/x-www-form-urlencoded; charset=utf-8",
			success:function(noPunSegments){
		//		alert("去标点结果成功返回！");
		//		alert(noPunSegments);
				$('#results').text("");// 清空数据
				$("#contents").empty();
				$("#boolResults").removeAttr("class");
				$("#invertedIndex").removeAttr("class");
				$("#segments").removeAttr("class");
				$("#noPun").attr("class","active");
				$('#results').append("<p style='color: rgb(255, 255, 255); font-size: 18px'></p>");
				$("p").append(noPunSegments);
		//		alert("去标点成功！");
				
			},
			error:function(){
				alert("去标点出错！");
				$("#results").text("");// 清空数据
				$("#contents").empty();
			}
		});

	});
});
</script>


<script type="text/javascript">
$(function() {//浏览文件
	$("#file").change(function() {
		//alert("浏览文件完毕！");
		//alert($("#file").val());
		var input  = document.getElementById("file"); //input file
		var file = input.files[0];
		//$("#fileName").val(file.name);
		$("#fileName").val($("#file").val());
	});
});

$(function() {//对提交的文件进行分词
	$("#split").click(function() {
		//alert("提交文件分词");
		//alert($("#file").val());
		var input  = document.getElementById("file"); //input file
		var file = input.files[0];
		var reader = new FileReader();
        reader.readAsText(file,"gbk");
        reader.onload = function(){
            $.ajax({
    			type:"POST",
    			url:"splitTxtFile",
    			data:{"fileContents":this.result},
    			datatype:"text",
    			contentType:"application/x-www-form-urlencoded; charset=utf-8",
    			success:function(splitTxt){
    				//alert("文件分词结果成功返回！");
    				//alert(splitTxt);
    				$('#results').text("");// 清空数据
    				$("#contents").empty();
    				$("#boolResults").removeAttr("class");
    				$("#invertedIndex").removeAttr("class");
    				$("#noPun").removeAttr("class");
    				$("#segments").attr("class","active");
    				$('#results').append("<p style='color: rgb(255, 255, 255); font-size: 18px'></p>");
    				$("p").append(splitTxt);
    				//alert("上传的文件分词成功！");
    				
    			},
    			error:function(){
    				alert("分词出错！")
    			}
    		}); 
        }
		 

	});
});

$(function() {//去除提交文件的标点
	$("#remove").click(function() {
		//alert("提交文件去标点");
		//alert($("#file").val());
		var input  = document.getElementById("file"); //input file
		var file = input.files[0];
		var reader = new FileReader();
        reader.readAsText(file,"gbk");
        reader.onload = function(){
            $.ajax({
    			type:"POST",
    			url:"removeTxtFile",
    			data:{"fileContents":this.result},
    			datatype:"text",
    			contentType:"application/x-www-form-urlencoded; charset=utf-8",
    			success:function(removeTxt){
    				//alert("文件去标点结果成功返回！");
    				//alert(removeTxt);
    				$('#results').text("");// 清空数据
    				$("#contents").empty();
    				$("#boolResults").removeAttr("class");
    				$("#invertedIndex").removeAttr("class");
    				$("#segments").removeAttr("class");
    				$("#noPun").attr("class","active");
    				$('#results').append("<p style='color: rgb(255, 255, 255); font-size: 18px'></p>");
    				$("p").append(removeTxt);
    				//alert("上传的文件去除标点成功！");
    				
    			},
    			error:function(){
    				alert("去标点出错！")
    			}
    		}); 
        }
		 

	});
});

</script>


<style type="text/css">
  a:link {color: white}
  a:visited{color:white}
  a:hover{color: black}
  a:active{color: black}
  .ra:visited{color:red}
</style>
</head>
<body style="background-color: rgb(73, 170, 199)" >>
	<nav class="navbar navbar-inverse">
		<div class="container" style="margin-left: 150px">
			<ul class="nav nav-pills">
				<li role="presentation"
					style="margin-right: 50px; width: 500px; height: 50px"><img
					src="images/IRLablogo.png" alt=""
					style="width: auto; height: auto; max-width: 100%; max-height: 100%"><span
					style="color: rgb(255, 255, 255); font-size: 20px">武汉大学信息检索与知识挖掘研究所</span></li>
				<li role="presentation" class="active" style="margin-top: 5px"><a
					href="#">语言检索模型</a></li>
				<li role="presentation" style="margin-left: 20px; margin-top: 5px"><a
					href="#">句法类API</a></li>
				<li role="presentation" style="margin-left: 20px; margin-top: 5px"><a
					href="#">篇章类API</a></li>
				<li role="presentation" style="margin-left: 20px; margin-top: 5px"><a
					href="#">下载类API</a></li>
				<li role="presentation" style="margin-left: 20px; margin-top: 5px"><a
					href="#">管理中心</a></li>
			</ul>
		</div>
	</nav>

	<div class="container">
		<div class="row" id="title" >
			<div class="col-md-5 col-md-offset-4">
				<h1 style="font: 200;">语言检索模型</h1>
			</div>
		</div>

		<div class="row" id="alone" style="margin-top: 100px">
			<div class="col-md-10 col-md-offset-2">
				<div class="form-group">
					<input type="file" id="file" class="form-control" style="display: none">
				</div>
			</div>
			<div class="col-md-4 col-md-offset-2">
				<label style="color:white" >请选择需要分词的文档：</label>
				<div class="input-group">
					<input type="text" class="form-control" id="fileName" >
					<div class="input-group-btn">
						<button id="browse" class="btn btn-default" type="button" onclick="$('#file').click();">浏览</button>
						<button id="split" class="btn btn-default" type="button" >分词</button>
						<button id="remove" class="btn btn-default" type="button">去标点</button>
					</div>

				</div>
			</div>
		</div>


           <div class="row" id="resutlnav">
               <div class="col-md-8 col-md-offset-2"  style="margin-top: 50px">
                   <ul class="nav nav-tabs" style="font-size: 18px">
                     <li id="segments" role="presentation" class="dropdown active" >
                         <a class="dropdown-toggle" data-toggle="dropdown" href="#"
                           role="button" aria-haspopup="true" aria-expanded="false">
                           分词结果<span class="caret"></span>
                       </a>
                       <ul id="dropdown1" class="dropdown-menu">
                       </ul>
                   </li>
                    <li id="noPun" role="presentation" class="dropdown">
                       <a class="dropdown-toggle" data-toggle="dropdown" href="#"
                           role="button" aria-haspopup="true" aria-expanded="false">
                            去标点符号结果<span class="caret"></span>
                        </a>
                        <ul  id="dropdown2" class="dropdown-menu">
                       </ul>
                    </li>
                     <li id="invertedIndex" role="presentation"><a href="#">索引</a></li>
                     <li id="boolResults" role="presentation"><a href="#" >检索结果</a></li>
               </ul>
               <br>
               </div>
           </div>

           <div class="row" id="resutlRow">
           <div class="col-md-10 col-md-offset-2" >
               <div class="col-md-10 row pre-scrollable" id="results" style="overflow:auto"><!-- style="overflow:auto" overflow-y:scroll -->
			<!-- 结果文档 -->
			<!-- <a id="user" class="ra" href="#">ra类的超链接测试</a> -->
			</div>
  			<div class="col-md-10 row pre-scrollable" id="contents" style="margin-top: 10px; overflow:auto; font-size: 15px; color:#C0C0C0 "><!-- 文档内容 --></div> 
		</div>
	</div>


		<div class="row" id="expressionTitle" style="margin-top: 50px">
			<div class="col-md-3 col-md-offset-2" >
				<label style="color: rgb(255, 255, 255); font-size: 18px">请输入想检索的内容：</label>
			</div>
		</div>

		<div id="expression">
			<div class="row">
				<div class="col-md-50 col-md-offset-2">
					<form class="form-inline">
						<div class="form-group">
							<input name="term" type="text"
								   placeholder="检索内容">
						</div>

					</form>
				</div>
			</div>
		</div>

		<div class="row" id="submitRow" style="margin-top: 20px">
			<div class="col-md-5 col-md-offset-2">
				<label id="boolExpr" style="color:white; font-size: 15px" ></label>
			</div>
			<div class="col-md-1">
				<form class="form-inline">
					&nbsp;
					<button id="search" type="button" class="btn btn-default">检索</button>
				</form>
			</div>
		</div>

	</div>
</body>
</html>