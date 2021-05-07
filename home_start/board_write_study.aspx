<%@ Register TagPrefix="INCLUDE" TagName="TOP" src="top.ascx" %>
<%@ Register TagPrefix="BOARD" TagName="TOP" src="board_top.ascx" %>
<%@ Register TagPrefix="INCLUDE" TagName="BOTTOM" src="bottom.ascx" %>
<%@ Import Namespace = "Study" %>

<%@ Page Language="C#" validateRequest="false" debug="true" %>
<%@ Register TagPrefix="FTB" Namespace="FreeTextBoxControls" Assembly="FreeTextBox" %>

<%@ Import Namespace = "System.Net.Mail" %>

<%@ Import Namespace = "System.Drawing" %>
<%@ Import Namespace = "System.Drawing.Imaging" %>

<script language="C#" runat="server">

// 수정기능 처음에는 false
bool IsEditMode = false;
string AttachedFile = "";

void Page_Load()
{
  if(!String.IsNullOrEmpty((string)Session["login_id"]))
  {
    lbluserIdentity.Text = (string)Session["login_id"] + "(" + (string)Session["login_nick"] + ")";
  }
  else lbluserIdentity.Text = "작자미상";
  lblDateTime.Text = DateTime.Now.ToString("yyyy년 MM월 dd일 HH시 mm분");

  //n 값이 넘어왔다면
  if(!String.IsNullOrEmpty(Request["n"]))
  {
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
      FreeTextBox1.Text = (string)dtModify.Rows[0]["content"];
      txtStudyType.Text = (string)dtModify.Rows[0]["StudyType"];
      
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

      // 기존 첨부파일을 폼으로 전송되게 저장
      hdnFile.Value = AttachedFile;
    }
  }
}

void btnWrite_Click(object sender, EventArgs e) // 수정완료 or 글쓰기 버튼 클릭 시
{
  string title = txtTitle.Text.Trim();
  string content = FreeTextBox1.Text.Trim();
  string StudyType = txtStudyType.Text.Trim();

  string message = "";  
  bool IsChecked = true;
    
  
  // 빈 값을 체크. || 는 OR 이다. ('~또는'라고 해석하자)
  // title이 빈 문자열이거나 content 가 빈 문자열이라면..
  if (title == "" || content.Equals(""))
  {
    IsChecked = false;
    message = "제목, 본문은 빈칸으로 올 수 없습니다.";
  }


  // 앞에서 패스하였다면.. 이제 업로드 체크 후 저장
  if (IsChecked)
  {
    // 업로드 파일명
    string upload_file = "";

    // 파일업로드는 옵션이다. 있으면 처리, 없으면 그냥 패스.
    // 파일업로드 컨트롤 ID는 'upload' 파일이 있으면 true
    if (upload.HasFile)
    {
      // 업로드 파일 경로
      string UPLOAD_PATH = Server.MapPath("./upload/");
      
      // 파일명을 변수에 저장(DB에 저장하기 위해)
      upload_file = upload.FileName;
      upload.SaveAs(UPLOAD_PATH + upload_file);
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

    string category = Request["c"]; // 카테고리는 GET으로 유지되고 있다.
    string user_id = "";
    string user_name = "";

    if(!String.IsNullOrEmpty((string)Session["login_id"])){
      user_id = (string)Session["login_id"]; // 로그인 세션 변수 id  
      user_name = (string)Session["login_nick"]; // 로그인 세션 변수 nick
    }
    else {
      user_id = "unknown";
      user_name = "작자미상";
    }

    // 최종 게시판 라이브러리는 데이터 저장.
    Board BOARD_LIB = new Board();

    // 수정 모드 추가
    if(IsEditMode){
      // 수정하기 (UPDATE)
      BOARD_LIB.Modify(Int32.Parse(Request["n"]), title, StudyType, content, upload_file);

      // 이후 글보기로 바로 이동
    Response.Redirect(
      "board_view.aspx?c=" + Request["c"] + "&n=" + Request["n"] + "&page=" + Request["page"]
      + "&stype=" + Request["stype"] + "&svalue=" + Request["svalue"]
      );
    }
    else{
    //공부내용 글쓰기 (INSERT)
    BOARD_LIB.Write(category, user_id, user_name, title, StudyType, content, upload_file);

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

void btnList_Click(object sender, EventArgs e) // 리스트로 버튼 클릭
{
  Response.Redirect("board_list.aspx?c=" + Request["c"]);
}

</script>

<INCLUDE:TOP runat="server" />
<BOARD:TOP runat="server" />
<!-- ----------------------------------여기서부터 내용 -------- -->

<div id="content">

<center>
<br>
<br>
<h1> <b> 공부 내용 기록 </b> </h1>
<br>
<form runat="server">
<table class="table">
  <tr> 
    <td class="table-primary"> 날짜 </td>
    <td> <ASP:Label id="lblDateTime" runat="server"/> </td>

    <td class="table-primary"> 스터디 종류 </td>
    <td> <ASP:TextBox class="form-control2" placeholder="스터디 종류를 입력하세요" id="txtStudyType" runat="server" /> </td>

    <td class="table-primary"> 작성자 </td>
    <td> <ASP:Label id="lbluserIdentity" runat="server" /> </td>
  </tr>

  <tr>
    <td class="table-primary" > 제목 </td>
    <td colspan="5"> <ASP:TextBox class="form-control2" placeholder="제목을 입력해주세요" id="txtTitle" runat="server" /> </td>
  </tr>

  <tr>
    <td class="table-primary"> 내용 </td>
    <!-- FREETEXTBOX 위에서 참조하여 사용함. -->
    <td colspan="8">
        <FTB:FreeTextBox id="FreeTextBox1" width="1200px" height="800"
        Focus="true"
        SupportFolder="~/aspnet_client/FreeTextBox/"
        JavaScriptLocation="ExternalFile" 
        ButtonImagesLocation="ExternalFile"
        ToolbarImagesLocation="ExternalFile"
        ToolbarStyleConfiguration="OfficeMac"			
        toolbarlayout="ParagraphMenu,FontFacesMenu,FontSizesMenu,FontForeColorsMenu,FontForeColorPicker,FontBackColorsMenu,FontBackColorPicker,Bold,Italic,Underline,Strikethrough,JustifyLeft,JustifyRight,JustifyCenter,JustifyFull,BulletedList,NumberedList,Indent,Outdent,CreateLink,Unlink,InsertImage,Cut,Copy,Paste,Delete;Undo,Redo,Print,Save,InsertTable,InsertImageFromGallery,SymbolsMenu"
        runat="Server"
        GutterBackColor="red"
        DesignModeCss="designmode.css"		 
        />
    </td>
  </tr>

  <tr>
    <td class="table-primary"> 첨부파일 </td>
    <td  colspan="7"> 
      <ASP:Literal id="liUpload" runat="server" />
      <ASP:FileUpload class="form-control-file" id="upload" runat="server"/> 
    </td>
  </tr>
  <tr>
    <td colspan="8" align="right"> 
      <ASP:Label id="lblError" runat="server" Text="" />
      <ASP:Button id="btnWrite" class="btn btn-success" runat="server" text="글쓰기" OnClick="btnWrite_Click" />
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
