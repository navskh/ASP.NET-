<%@ Register TagPrefix="INCLUDE" TagName="TOP" src="top.ascx" %>
<%@ Register TagPrefix="BOARD" TagName="TOP" src="board_top.ascx" %>
<%@ Register TagPrefix="INCLUDE" TagName="BOTTOM" src="bottom.ascx" %>
<%@ Import Namespace = "Study" %>

<%@ Import Namespace = "System.Drawing" %>
<%@ Import Namespace = "System.Drawing.Imaging" %>

<script language="C#" runat="server">

// 수정기능 처음에는 false
bool IsEditMode = false;
string AttachedFile = "";

void Page_Load(){

  lbluserIdentity.Text = (string)Session["login_id"];
  //n 값이 넘어왔다면
  if(!String.IsNullOrEmpty(Request["n"]))
  {
    // 수정 기능 나중에 구현해 줘야 함!!

    // 수정기능 on
    IsEditMode = true;

    if(!IsPostBack)
    {
      // 데이터 가져오기
    string CATEGORY_ID = Request["c"];
    int BOARD_ID = Int32.Parse(Request["n"]);

    Board BOARD_LIB = new Board();
    System.Data.DataTable dtModify = BOARD_LIB.Read(CATEGORY_ID,BOARD_ID);

    //텍스트 박스에 넣어주기
    txtTitle.Text = (string)dtModify.Rows[0]["title"];
    txtContent.Text = (string)dtModify.Rows[0]["content"];

    //파일 첨부체크, 첨부가 없으면 컬럼값은 공백("")이다.
    if((string)dtModify.Rows[0]["file_attach"] != "")
    {
      // 파일이 있다면
      // 기존 첨부파일 내용을 표시
      liUpload.Text = "첨부된 파일 : " + dtModify.Rows[0]["file_Attach"];
      
      // 첨부된 파일의 파일명을 저장해줌
      AttachedFile = (string)dtModify.Rows[0]["file_attach"];
    }
      // 시각요소 변경
      btnWrite.Text = "수정완료";

      hdnFile.Value = AttachedFile;
      // 기존 첨부파일을 폼으로 전송되게 저장
    }
    
  }
}
void btnWrite_Click(object sender, EventArgs e)
{
  string title = txtTitle.Text.Trim();
  string content = txtContent.Text.Trim();
  string 
  
  string message = "";  
  bool IsChecked = true;
    
  
  // 빈 값을 체크. || 는 OR 이다. ('~또는'라고 해석하자)
  // title이 빈 문자열이거나 content 가 빈 문자열이라면..
  if (title == "" || 
  content.Equals("") ||
  )
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
      string UPLOAD_PATH = Server.MapPath("./upload/");
      
      // 파일명을 변수에 저장(DB에 저장하기 위해)
      upload_file = upload.FileName;
      upload.SaveAs(UPLOAD_PATH + upload_file);

      // --------------------------------섬네일 만들기
      // 비트맵 클래스로 첨부파일 이미지를 불러옴
      Bitmap img = new Bitmap(UPLOAD_PATH + upload_file);
      // Graphics 객체를 시작한다.
      Graphics g = Graphics.FromImage(img);

      // 크기 변경
      Bitmap img_newsize = new Bitmap(80, 60);
      g = Graphics.FromImage(img_newsize);
      g.DrawImage(img, 0, 0, 80, 60);
      
      // 저장
      img_newsize.Save(UPLOAD_PATH + "small_" + upload_file, ImageFormat.Jpeg);

      // 메모리 해제
      img.Dispose();
      img_newsize.Dispose();
      g.Dispose();
      //섬네일 만들기 끝

    }

    // -------[수정 모드 추가]--------
    // 첨부파일이 없다고 해도 기존에 파일이 있다면 기존 파일명으로 저장
    else 
    {
      if (hdnFile.Value != "")
        upload_file = hdnFile.Value;
    }

    // 실제 글쓴 자료 저장하기
    // board 테이블 : category, user_id, user_name, "title", "content", "file_attach"
    // ("" 필드는 사용자 입력값)

    string category = Request.QueryString["c"]; // 카테고리는 GET으로 유지되고 있다.
    string user_id = (string)Session["login_id"]; // 로그인 세션 변수 id
    string user_name = (string)Session["login_nick"]; // 로그인 세션 변수 nick

    // 최종 게시판 라이브러리는 데이터 저장.
    Board BOARD_LIB = new Board();

    // 수정 모드 추가
    if(IsEditMode){
      // 수정기능
      BOARD_LIB.Modify(Int32.Parse(Request["n"]), title, content, upload_file);

      // 이후 글보기로 바로 이동
    Response.Redirect(
      "board_view.aspx?c=" + Request["c"] + "&n=" + Request["n"] + "&page=" + Request["page"]
      + "&stype=" + Request["stype"] + "&svalue=" + Request["svalue"]
      );
    }
    else{
      //새글 쓰기
    BOARD_LIB.Write(category, user_id, user_name, title, content, upload_file);

    // 이후 리스트로 바로 이동 ('c' 값은 계속 유지)
    Response.Redirect("board_list.aspx?c=" + Request["c"]);
    }
    
  }

  else
  {
    // IsChecked 가 false 이면 오류. 메시지만 뿌리자.
    lblError.Text = message;
  }

  
}

void btnList_Click(object sender, EventArgs e)
{
  Response.Redirect("board_list.aspx?c=" + Request["c"]);
}

</script>

<INCLUDE:TOP runat="server" />
<BOARD:TOP runat="server" />
<!-- ----------------------------------여기서부터 내용 ---------->



<div id="content">

<center>
<br>
<br>
<h1> PIMS 요청 </h1>
<form runat="server">
<table class="table">
  <tr> 
    <td class="table-primary">이름(아이디) </td>
    <td colspan="8"> <ASP:Label id="lbluserIdentity" runat="server"/> </td>
  </tr>

  <tr>
    <td class="table-primary"> 서비스 명 </td>
    <td > <ASP:TextBox class="form-control2" id="txtServiceName" runat="server" /> </td>

    <td class="table-primary"> 서비스ID </td>
    <td > <ASP:TextBox class="form-control2" id="txtServiceID" runat="server" /> </td>

    <td class="table-primary"> 개발 담당자 </td>
    <td > 
      <ASP:DropDownList class="form-control2" id="DeveloperList" runat="server">
        <ASP:ListItem value="PD1" text="개발자1" />
        <ASP:ListItem value="PD2" text="개발자2" /> 
      </ASP:DropDownList>
    </td>

    <td class="table-primary"> 글 상태 </td>
    <td > 
      <ASP:DropDownList class="form-control2" id="contentCondition" runat="server">
        <ASP:ListItem value="ready" text="접수" />
        <ASP:ListItem value="inprogress" text="처리중" /> 
        <ASP:ListItem value="finish" text="완료" /> 
        <ASP:ListItem value="delay" text="지연" /> 
        <ASP:ListItem value="cannot" text="불가" /> 
      </ASP:DropDownList>
    </td>
  </tr>

  <tr>
    <td class="table-primary" > 제목 </td>
    <td colspan="5"> <ASP:TextBox class="form-control2" id="txtTitle" runat="server" /> </td>
    <td class="table-primary"> 대분류 </td>
    <td >
      <ASP:DropDownList class="form-control2" id="Board_Type" runat="server">
        <ASP:ListItem value="board_type1" text="유형1" />
        <ASP:ListItem value="board_type2" text="유형2" /> 
        <ASP:ListItem value="board_type3" text="유형3" /> 
        <ASP:ListItem value="board_type4" text="유형4" /> 
        <ASP:ListItem value="board_type5" text="유형5" /> 
      </ASP:DropDownList>
    </td>
  </tr>

  <tr> 
    <td class="table-primary"> 내용 </td>
    <td  colspan="8" height="10"> <ASP:TextBox id="txtContent" textmode="Multiline" placeholder="내용을 입력하세요" 
    class="form-control2" runat="server" Columns="90" Rows="10"/> 
    </td>
  </tr>

  <tr>
    <td class="table-primary"> 첨부파일 </td>
    <td  colspan="7"> 
      <ASP:Literal id="liUpload" runat="server" />
      <ASP:FileUpload class="form-control-file" id="upload" runat="server"/> 
    </td>
  </tr>
  <tr> </tr>
  <tr>
    <td colspan="8" align="right"> 
      <ASP:Label id="lblError" runat="server" Text="" />
      <ASP:Button id="btnWrite" class="btn btn-info" runat="server" text="글쓰기" OnClick="btnWrite_Click" />
      <ASP:Button margin-right="auto" id="btnList" class="btn btn-warning" runat="server" text="리스트로" OnClick="btnList_Click" />
    </td>
  </tr>

  <tr>
    <td>
    
    </td>
  </tr>
</table>
<input type="hidden" id="hdnFile" runat="server" />

</form>
</center>
</div>

<!-- ----------------------------------내용 끝 ---------->
<INCLUDE:BOTTOM runat="server" />