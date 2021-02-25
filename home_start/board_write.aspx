<%@ Register TagPrefix="INCLUDE" TagName="TOP" src="top.ascx" %>
<%@ Register TagPrefix="INCLUDE" TagName="BOTTOM" src="bottom.ascx" %>
<%@ Import Namespace = "Study" %>


<script language="C#" runat="server">
void btnWrite_Click(object sender, EventArgs e)
{
  string title = txtTitle.Text.Trim();
  string content = txtContent.Text.Trim();
  
  string message = "";  
  bool IsChecked = true;
    
  
  // 빈 값을 체크. || 는 OR 이다. ('~또는'라고 해석하자)
  // title이 빈 문자열이거나 content 가 빈 문자열이라면..
  if (title == "" || content.Equals(""))
  {
    IsChecked = false;
    message = "제목이나 내용은 빈 칸으로 둘 수 없습니다.";
  }


  // 앞에서 패스하였다면.. 이제 업로드 체크 후 저장
  if (IsChecked)
  {
    
    // 업로드 파일명
    string upload_file = "";

    // 파일업로드는 옵션이다. 있으면 처리, 없으면 그냥 패스.
    // 파일업로드 컨트롤 ID는 'upload'
    // 파일이 있으면 true
    if (upload.HasFile)
    {
      // 업로드 파일 경로
      string UPLOAD_PATH = Server.MapPath("/upload/");
      
      // 파일명을 변수에 저장(DB에 저장하기 위해)
      upload_file = upload.FileName;
      upload.SaveAs(UPLOAD_PATH + upload_file);
    }

    
    // 실제 글쓴 자료 저장하기
    // board 테이블 : category, user_id, user_name, "title", "content", "file_attach"
    // ("" 필드는 사용자 입력값)

    string category = Request.QueryString["c"]; // 카테고리는 GET으로 유지되고 있다.
    string user_id = (string)Session["login_id"]; // 로그인 세션 변수 id
    string user_name = (string)Session["login_nick"]; // 로그인 세션 변수 nick

    // 최종 게시판 라이브러리는 데이터 저장.
    Board BOARD_LIB = new Board();
    BOARD_LIB.Write(category, user_id, user_name, title, content, upload_file);

    // 이후 리스트로 비로 이동 ('c' 값은 계속 유지)
    Response.Redirect("board_list.aspx?c=" + Request["c"]);
  }

  else
  {
    // IsChecked 가 false 이면 오류. 메시지만 뿌리자.
    lblError.Text = message;
  }

  
}

</script>

<INCLUDE:TOP runat="server" />
<!-- ----------------------------------여기서부터 내용 ---------->



<div id="content">

글쓰기
<form runat="server">

<span>
  제목
  <ASP:TextBox id="txtTitle" runat="server" />

  <br>
  내용 
  <br>
  <ASP:TextBox id="txtContent" textmode="Multiline" runat="server" Columns="90" Rows="10"/>

  <br>
  <ASP:FileUpload id="upload" runat="server"/>

  <br>
  <ASP:Button id="btnWrite" runat="server" text="글쓰기" OnClick="btnWrite_Click" />
  
  <ASP:Label id="lblError" runat="server" Text="lblError값" />
</span>

</form>

</div>

<!-- ----------------------------------내용 끝 ---------->
<INCLUDE:BOTTOM runat="server" />