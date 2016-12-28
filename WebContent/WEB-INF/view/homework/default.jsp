<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<head>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	<link href="/css/homework.css" rel="stylesheet" >
</head>
<style>
input[type="text"], textarea{	
	background-color : white;
	border: none;
	padding : 5px;
}
#porblemView{
	style : background-color: white;
}
div{
	margin : 0px;
	padding : 0px;
}
section{
	border: 1px solid gray;	
}

label{
	padding : 5px;
}
</style>

<div class = 'w3-container w3-row' style='margin : 0px; padding : 0px;'>
	<form id='homeworkForm' >
	<div id='problemViewWrap' class='w3-col l5 m6' >
		
			<input type='hidden' name='writer' value='${login.ID }'>
			<input type='hidden' name='loginClass' value='${login.CLASS }'>			
			<input type='hidden' name='num' value='${pojo.num }' >					
			 <label>제목 :</label><input id='title' type='text' name='title' value='${pojo.title }'
				readonly="readonly" required><br />
			<textarea id='problemView' name='content' readonly="readonly" style='width: 100%' >
				${pojo.content }
			</textarea>
			<br />
			<section id='inputExam' class='w3-col l6 m12' >
				<div class='headline'>입력 예제</div>
				<textarea class='examPre' readonly="readonly" name='input'>
					${pojo.input }
				</textarea>
			</section>
			<section id='outputExam' class='w3-col l6 m12' >
				<div class='headline'>출력 예제</div>
					<textarea class='examPre' readonly="readonly" name='output'>
					${pojo.output }
				</textarea>
			</section>
			<br/>
		<div id='rankView' class='w3-col l12' ></div>
	</div>
	
<!-- SourceCode -->	
	<div id='sourceCodeWrap' class='w3-col l7 m6' >
		<label>Class Name &nbsp;&nbsp; : </label>
		<input id='className' type="text" name="className" readonly="readonly" required value="${pojo.num }" ><br/>
		<label>Method Name : </label>
		<input id='methodName' type="text" name="methodName" readonly="readonly"
			 required value="${pojo.num }" style="margin-left: -2px;">
			 	
		<textarea id='sourceCode' name='content' cols='80' rows='20' style='margin: 0px'>
			class Homework{
				public static void main(String[] args){
					System.out.println("Hello! WebCoding~~");
				}
			}
		</textarea>	
		<br/>
		
		<div id='consoleView' ></div>
		<div id='controllBar' align='center' >
			<input id='run' type='button' value='실행' >
		</div>	
	</div>
</form> <!-- homeworkForm -->
</div> <!-- container -->

<!-- Modal dialog -->
<div class="modal fade" id="myModal" role="dialog">
    <div class="modal-dialog modal-sm">    
      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title">경 고</h4>
        </div>
        <div class="modal-body">
          <p>정말 삭제 하시겠습니까?</p>
        </div>
        <div class="modal-footer" >
          <button id="deleteConfirm" type="button" class="btn btn-danger" >Delete</button>
          <button type="button" class="btn btn-info" data-dismiss="modal">Cancel</button>
        </div>
      </div>
      
    </div>
</div><!-- Modal -->


<script>
	var lastRank = 0;	
	
	var path = location.pathname.split("/");
	console.log(path);
	console.log(path[2]);
	console.log()
	$(document).ready(function(){
		console.log($("#headtemp").html());
		switch(path[2]){
		case "admin" :
			if (path[3] == 'writeForm') {
				$("input[type='hidden'][name='num']").removeAttr("name");
				$("textarea, input[type='text']").attr("readonly", false).css("background-color", "white")
					.css("border", "1px solid aqua");
				$("#run").after("<input id='regist' type='button' value='글쓰기' >");
				$("#regist").click(function(e) {
					alert("submit");
					insertHomework("write");					
				});
			}else if(path[3] == "read" ){
				$("#homeworkNav").append("<li id='modi' ><a>수정</a></li>")
					.append("<li id='delete' ><a>삭제</a></li>");
			}
			break;
		case "student" :
			
			break;		
		default:
			break;
		}
		$("#homeworkNav li:gt(0)").on("click", function(){
			switch($(this).find("a").html()){
			case "수정":
				console.log($("textarea"));
				console.log($("input[type='text']"));
				$("textarea, input[type='text']").attr("readonly", false).css("background-color", "white")
					.css("border", "1px solid aqua");				 
				$("#modi > a").html("완료");
				break;
			case "완료":
				insertHomework("modify");
				break;
			case "삭제":
				$("#myModal").modal();
				break;
			default :
				break;
			}
		});
		var height = $("#problemViewWrap").css("height");
		console.log("height: "+height);
		$("#sourceCodeWrap").css("height", height);
		$("#sourceCode").css("height", "60%");
		$("#consoleView").css("height", "25%");
		
	});	// document onload
	
	//Event Handler	
	$('#deleteConfirm').click(function(e){
		insertHomework("delete");
	});
	
	$("#run").on("click", function() {
		compile();		
	});
	
	
	function insertHomework(insertType){
		var hwData;
		switch(insertType){
		case "write":
			hwData = $("#homeworkForm").serializeArray();
			var source = {
				name : "source",
				value : $(sourceCode).val()
			};
			hwData.push(source);
			break;
		case "modify":
			hwData = $("#homeworkForm").serializeArray();
			var source = {
				name : "source",
				value : $(sourceCode).val()
			};
			hwData.push(source);
			break;
		case "delete":
			hwData = { num : $("input[type='hidden'][name='num']").val() };
			break;
		default:
			break;
		}
		
		console.log(hwData);
		
		$.ajax({
			url : "/hw/admin/"+insertType,
			type : "post",
			async : false,
			data : hwData,
			success : function(data) {
				console.log(data);
				if (data == 0)
					alert("입력 실패")
				else {
					alert("Success!!!");
					$("textarea", "input").attr("readonly", "readonly");
				}
			},
			error : function(data, source, err) {
				console.log(data);
				console.log(source);
				alert(err + "\n입력 실패하였습니다.");
			}
		});
	}
	// handle <tab> in textarea
	$(document).delegate('#sourceCode', 'keydown', function(e) {
	  var keyCode = e.keyCode || e.which;
	  console.log(e.keycode);
	  console.log(e.which);
	  console.log(keyCode);
	  if (keyCode == 9) {
	    e.preventDefault();
	    var start = $(this).get(0).selectionStart;
	    var end = $(this).get(0).selectionEnd;
	
	    // set textarea value to: text before caret + tab + text after caret
	    $(this).val($(this).val().substring(0, start)
	                + "\t"
	                + $(this).val().substring(end));
	
	    // put caret at right position again
	    $(this).get(0).selectionStart =
	    $(this).get(0).selectionEnd = start + 1;
	  }
	});
	function compile(){
		var $answer = $("#sourceCode").val();
 		var className = $("#className").val();
 		var methodName = $("#methodName").val();
 		$.ajax({
			url : "/hw/compile",
			type : "post",
			data : {
				"java" : $answer,
				"className" : className,
				"methodName" : methodName
			},
			success : function(r){
		 		$("#consoleView").empty();
		 		$("#consoleView").append(r+"<br/>");
		 		checkAnswer(r);
			}
		});
	}
	function checkAnswer(r){ 		

		if(r==answer){
			$("#consoleView").append("<span class='correct' >Correct!!!</span><br/>");
			recordRank();
		}else{
			$("#consoleView").append("<span class='incorrect' >incorrect..</span><br/>");
		}	
	}
	
	function recordRank(){
		ws.send("aaa");
		$("#rankView").append((lastRank+1), " aaa", "<br/>");
		lastRank++;
	}
	
	// WebSocket	
	var ws = new WebSocket("ws://${header.host}/homework/homesocket");
	ws.onopen = function(args) {
		console.log("connect.");
	};
	ws.onmessage = function(e) {
		console.log(e.data);
	}
	
	
</script>
