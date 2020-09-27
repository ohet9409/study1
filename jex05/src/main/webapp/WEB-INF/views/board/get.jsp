<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@include file="../includes/header.jsp"%>


<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">Board Read</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">

			<div class="panel-heading">Board Read Page</div>
			<!-- /.panel-heading -->
			<div class="panel-body">

				<div class="form-group">
					<label>Bno</label> <input class="form-control" name='bno'
						value='<c:out value="${board.bno }"/>' readonly="readonly">
				</div>

				<div class="form-group">
					<label>Title</label> <input class="form-control" name='title'
						value='<c:out value="${board.title }"/>' readonly="readonly">
				</div>

				<div class="form-group">
					<label>Text area</label>
					<textarea class="form-control" rows="3" name='content'
						readonly="readonly"><c:out value="${board.content}" /></textarea>
				</div>

				<div class="form-group">
					<label>Writer</label> <input class="form-control" name='writer'
						value='<c:out value="${board.writer }"/>' readonly="readonly">
				</div>

				<%-- 		<button data-oper='modify' class="btn btn-default">
        <a href="/board/modify?bno=<c:out value="${board.bno}"/>">Modify</a></button>
        <button data-oper='list' class="btn btn-info">
        <a href="/board/list">List</a></button> --%>


				<button data-oper='modify' class="btn btn-default">Modify</button>
				<button data-oper='list' class="btn btn-info">List</button>

				<%-- <form id='operForm' action="/boad/modify" method="get">
  <input type='hidden' id='bno' name='bno' value='<c:out value="${board.bno}"/>'>
</form> --%>


				<form id='operForm' action="/boad/modify" method="get">
					<input type='hidden' id='bno' name='bno'
						value='<c:out value="${board.bno}"/>'> <input
						type='hidden' name='pageNum'
						value='<c:out value="${cri.pageNum}"/>'> <input
						type='hidden' name='amount' value='<c:out value="${cri.amount}"/>'>
					<input type='hidden' name='keyword'
						value='<c:out value="${cri.keyword}"/>'> <input
						type='hidden' name='type' value='<c:out value="${cri.type}"/>'>

				</form>



			</div>
			<!--  end panel-body -->

		</div>
		<!--  end panel-body -->
	</div>
	<!-- end panel -->

</div>
<!-- /.row -->
<div class='row'>

	<div class="col-lg-12">

		<!-- /.panel -->
		<div class="panel panel-default">
			<!--       <div class="panel-heading">
        <i class="fa fa-comments fa-fw"></i> Reply
      </div> -->

			<div class="panel-heading">
				<i class="fa fa-comments fa-fw"></i> Reply
				<button id='addReplyBtn' class='btn btn-primary btn-xs pull-right'>New
					Reply</button>
			</div>


			<!-- /.panel-heading -->
			<div class="panel-body">

				<ul class="chat">

				</ul>
				<!-- ./ end ul -->
			</div>
			<!-- /.panel .chat-panel -->

			<div class="panel-footer"></div>


		</div>
	</div>
	<!-- ./ end row -->
</div>
<!-- Modal -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
	aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"
					aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">REPLY MODAL</h4>
			</div>
			<div class="modal-body">
				<div class="form-group">
					<label>Reply</label> <input class="form-control" name='reply'
						value='New Reply!!!!'>
				</div>
				<div class="form-group">
					<label>Replyer</label> <input class="form-control" name='replyer'
						value='replyer'>
				</div>
				<div class="form-group">
					<label>Reply Date</label> <input class="form-control"
						name='replyDate' value='2018-01-01 13:13'>
				</div>

			</div>
			<div class="modal-footer">
				<button id='modalModBtn' type="button" class="btn btn-warning">Modify</button>
				<button id='modalRemoveBtn' type="button" class="btn btn-danger">Remove</button>
				<button id='modalRegisterBtn' type="button" class="btn btn-primary">Register</button>
				<button id='modalCloseBtn' type="button" class="btn btn-default">Close</button>
			</div>
		</div>
		<!-- /.modal-content -->
	</div>
	<!-- /.modal-dialog -->
</div>
<!-- /.modal -->
<script type="text/javascript" src="/resources/js/reply.js">

</script>

<script type="text/javascript">

console.log("============");
console.log("JS TEST");

var bnoValue = '<c:out value="${board.bno}"/>';
var replyUL = $(".chat");

showList(1);

function showList(page) {
	replyService.getList({bno:bnoValue, page:page||1}, function(replyCnt, listA) {
		
		console.log("replyCnt: " + replyCnt);
		console.log("listA: " + listA);
		console.log(listA);
		
		if(page == -1){
			pageNum = Math.ceil(replyCnt/10.0);
			showList(pageNum);
			return;
		}
		
		var str = "";
		if (listA == null || listA.length == 0) {
			replyUL.html("");
			return;
		}
		for (var i = 0, len = listA.length || 0; i < len; i++) {
			str += "<li class='left clearfix' data-rno='"+listA[i].rno+"'>";
			str += " <div><div class='header'><strong class='primary-font'>"+listA[i].replyer+"</strong>";
			str += " <small class='pull-right text-muted'>" + replyService.displayTime(listA[i].replyDate) + "</small></div>";
			str += " <p>" + listA[i].reply+"</p></div></li>";
		}
		replyUL.html(str);
		
		showReplyPage(replyCnt);	//댓글 페이지 표시
	}); // end function
}//end showList

console.log("=====댓글 등록======");
var modal = $('.modal');
var modalInputReply = modal.find("input[name='reply']");
var modalInputReplyer = modal.find("input[name='replyer']");
var modalInputReplyDate = modal.find("input[name='replyDate']");

var modalModBtn = $('#modalModBtn');
var modalRemoveBtn = $('#modalRemoveBtn');
var modalRegisterBtn = $('#modalRegisterBtn');
var modalCloseBtn = $('#modalCloseBtn');

$('#addReplyBtn').on("click", function (e) {
	console.log("=====addReplyBtn======");
	
	modal.find("input").val("");
	modalInputReplyDate.closest("div").hide();
	modal.find("button[id != 'modalCloseBtn']").hide();
	
	modalRegisterBtn.show();
	
	$('.modal').modal("show");
});

modalRegisterBtn.on("click", function(e){
	
	var reply = {
		reply : modalInputReply.val(),
		replyer : modalInputReplyer.val(),
		bno: bnoValue
	};
	
	replyService.add(reply, function(result) {
		alert(result);
		
		modal.find("input").val("");
		modal.modal("hide");
		
		//showList(1);
		showList(-1);
	});
});

$("#modalCloseBtn").on("click", function(e){
	
	modal.modal('hide');
});


$('.chat').on("click", "li", function(e) {
	var rno = $(this).data("rno");
	
	replyService.get(rno, function(reply) {
		
		modalInputReply.val(reply.reply);
		modalInputReplyer.val(reply.replyer);
		modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly","readonly");
		modal.data("rno", reply.rno);
		
		modal.find("button[id != 'modalCloseBtn']").hide();
		modalModBtn.show();
		modalRemoveBtn.show();
		
		$(".modal").modal("show");
	});
	
	modalModBtn.on("click", function(e) {
		
		var reply = {rno: modal.data("rno"), reply: modalInputReply.val()};
		
		replyService.update(reply, function(result) {
			
			alert(result);
			modal.modal("hide");
			//showList(1);
			showList(pageNum);
		});
	});
	
	modalRemoveBtn.on("click",function(e){
		
		var rno = modal.data("rno");
		
		replyService.remove(rno,function(result){
			
			alert(result);
			modal.modal("hide");
			//showList(1);
			showList(pageNum);
		});
	});
	console.log(rno);
});

var pageNum = 1;
var replyPageFooter = $(".panel-footer");

function showReplyPage(replyCnt) {
	
	var endNum = Math.ceil(pageNum / 10.0) * 10;
	var startNum = endNum - 9;
	
	var prev = startNum != 1;
	var next = false;
	
	if(endNum * 10 >= replyCnt){
		endNum = Math.ceil(replyCnt/10.0);
	}
	
	if(endNum * 10 < replyCnt){
		next = true;
	}
	
	var str = "<ul class= 'pagination pull-right'>";
	
	if (prev) {
		str += "<li class='page-item'><a class= 'page-link' href= '"+(startNum -1)+"'>Previous</a></li>";
	}
	
	for(var i = startNum; i <= endNum; i++){
		var active = pageNum == i ? "active" : "";
		str += "<li class='page-item " +active+" '><a class='page-link' href='"+i+"'>" + i + "</a></li>"; 
	}
	
	if(next){
		str += "<li class='page-item'><a class='page-link' href= '" + (endNum +1)+"'> Next</a></li>";
	}
	
	str += "</ul></div>";
	
	console.log(str);
	
	replyPageFooter.html(str);
}

replyPageFooter.on('click', "li a", function(e) {
	e.preventDefault();
	console.log("page click");
	
	var targetPageNum = $(this).attr("href");
	
	console.log("targetPageNum: " + targetPageNum);
	
	pageNum = targetPageNum;
	
	showList(pageNum);
});

// 111번 댓글 가져오기 테스트
/* replyService.get(111, function(data) {
	console.log(data);
}); */

// 111번 댓글 수정 테스트
/* replyService.update({
		rno : 111,
		bno : bnoValue,
		reply : "Modified Reply...."
	}, function(result) {
		alert("수정완료");
	}
); */

// 112번 댓글 삭제 테스트
/* replyService.remove(112, function(count){
	
	console.log(count);
	
		if(count === "success"){
			alert("removed");
		}

	}, function(err) {
		alert('ERROR..');
	}
); */

//for replyService getList test
/* replyService.getList({bno:bnoValue, page:1}, function(list) {
	
	for(var i = 0, len = list.length||0; i < len; i++){
		console.log(list[i]);
	}
}); */

// for replyService add test
/* replyService.add(
	{reply: "JS TEST", replyer: "tester", bno: bnoValue}
	, function(result) {
		alert("RESULT: " + result);
	}
); */

$(document).ready(function() {
	console.log(replyService);
});
</script>
<script type="text/javascript">
$(document).ready(function() {
  
  var operForm = $("#operForm"); 
  
  $("button[data-oper='modify']").on("click", function(e){
    
    operForm.attr("action","/board/modify").submit();
    
  });
  
    
  $("button[data-oper='list']").on("click", function(e){
    
    operForm.find("#bno").remove();
    operForm.attr("action","/board/list")
    operForm.submit();
    
  });  
});
</script>


<%@include file="../includes/footer.jsp"%>
