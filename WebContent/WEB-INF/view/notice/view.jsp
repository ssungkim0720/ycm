<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- �������� �������� �������� �дº�  <br/> -->

<b>���� : </b>${noticeview.NOTICE_TITLE } <br/>
<b>��ȸ�� : </b>${noticeview.NOTICE_COUNT} <br/>
<b>�ۼ��� : </b>${noticeview.NOTICE_WRITER} <br/>
<b>����  </b>${noticeview.NOTICE_CONTENT } <br/>



<hr/>
	<input type="button"  class="btn btn-default" value="���" onclick="javascript:location.href='/notice'"/>
<c:if test="${login.CLASS=='master'}">	
	<input type="button"  class="btn btn-default" value="�ۼ���" onclick="javascript:location.href='/notice/rewrite/${noticeview.NOTICE_NUM}'"/>
	<button type="button"  class="btn btn-default" data-toggle="modal" data-target="#myModal" >�ۻ���</button>
</c:if>

<hr/>
��۳�����.... <br/>
<form action="/comment/input" method="post">
	<input type="hidden" name="num" value="${noticeview.NOTICE_NUM}"/> 
	<input type="hidden" name="writer" value="${login.NAME}">
	<input type="text" name="content" required="required"> <input type="submit"  class="btn btn-default" value="��۵��" />
</form> 
<div>
	foreach....<br/>
	notice num���� ��� ����Ʈ.. 
	��ϵ� ��� ����,���� (����� �����)
	�����ڴ� ���� ������ư �հ�.. 
</div>


  <!-- �� ���� ��ư Modal -->
  <div class="modal fade" id="myModal" role="dialog">
    <div class="modal-dialog">
    
      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
        </div>
        <div class="modal-body">
          <p>�����Ͻðڽ��ϱ�?</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal" onclick="javascript:deleteYes()">Ȯ��</button>
          <button type="button" class="btn btn-default" data-dismiss="modal" >���</button>
        </div>
      </div>
      
    </div>
  </div>
  
 <script>
 function deleteYes() {
	 	location.href="/notice/delete/${noticeview.NOTICE_NUM}";
	 }
</script>
  
  