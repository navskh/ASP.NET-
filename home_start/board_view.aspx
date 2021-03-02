<%@ Register TagPrefix="INCLUDE" TagName="TOP" src="top.ascx" %>
<%@ Register TagPrefix="BOARD" TagName="TOP" src="board_top.ascx" %>

<%@ Register TagPrefix="INCLUDE" TagName="BOTTOM" src="bottom.ascx" %>
<%@ Import Namespace = "Study" %>
<%@ Import Namespace = "System.Data" %>

<script language="C#" runat="server">
  string CATEGORY_ID;
  int BOARD_ID;

  int NOW_PAGE;
  int RecommendFlag;

    void Page_Load(){

      if(String.IsNullOrEmpty(Request["page"]))
      {
        // 무조건 오류
        // 오류 처리 생략
    
      }

      else
      {
        NOW_PAGE = Int32.Parse(Request["page"]);
      }
      //로그인 체크   
      // 로그인이 안되어 있으면 쓰기 영역 없애기
      if (Session["login_id"] == null)
        tblCommentWrite.Visible = false;
      //로그인 되었으면 작성자 Label 넣기
      else 
      lblWriter.Text = (string)Session["login_nick"];
      
      
      
      CATEGORY_ID = Request["c"];
      BOARD_ID = Int32.Parse(Request["n"]);
      Board BOARD_LIB = new Board();
      DataTable dtView = BOARD_LIB.Read(CATEGORY_ID, BOARD_ID);
      DataRow row = dtView.Rows[0];

      

      lblTitle.Text = (string)row["title"];
      lblName.Text = String.Format("{0} ({1})", row["user_name"], row["regdate"]);
      lblRead.Text = row["readnum"].ToString();
      lblRecommend.Text = row["recommend"].ToString();
      lblContent.Text = (string)row["content"];

      RecommendFlag = BOARD_LIB.RecommendCheck((string)Session["login_id"],BOARD_ID);
      if(RecommendFlag == 1){
        btnRecommend.Text = "추천취소";
      }
      else btnRecommend.Text = "추천하기";
    


      if ((string)row["file_attach"] != "")
        lblFile.Text = String.Format("<a href='upload/{0}'>{1}</a>", row["file_attach"], row["file_attach"]);

      else lblFile.Text = "없음";

      // 처음 열었을 때
      if (!IsPostBack)
      {
        CommentList();
        BOARD_LIB.ReadUp(CATEGORY_ID, BOARD_ID);

        lblRead.Text = (Int32.Parse(lblRead.Text)+1).ToString(); // 처음 열었을 때 조회수 맞춰줌.

        // 수정, 삭제 기능 활성화 체크
        if(!String.IsNullOrEmpty((string)Session["login_id"])){
          if((string)Session["login_id"] == (string)row["user_id"])
          {
            trModifyDelete.Visible = true;
          }
        }
      }
    }

  void btnCommentWrite_Click(object source, EventArgs e)
  {
    string MESSAGE = "";
    string comment = txtComment.Text.Trim();

    // 댓글 내용 공백
    if (comment.Length == 0)
    {
      MESSAGE = "[!] <font color=red> 댓글등록필요. </font>";
      // 상태관리 (ViewState) 로 인해 입력 내용이 남아있게 되므로 없애줌  
    }
    else
    {
      Board BOARD_LIB = new Board();
      BOARD_LIB.CommentWrite(BOARD_ID, (string)Session["login_id"], (string)Session["login_nick"], comment);

      MESSAGE = "[!] <font color=blue>댓글이 있음</font>";
      txtComment.Text = "";

      CommentList();
    }

    //결과 메세지 출력
    tblCommentWrite.Rows[0].Cells[1].Controls.Add(new LiteralControl(MESSAGE));
  }

  void CommentList()
	{
      Board BOARD_LIB = new Board();
      //------- 댓글 
      // 다음처럼 굳이 DataTable 을 따로 선언하지 않아도 된다.
      
      rptComment.DataSource = BOARD_LIB.CommentList(BOARD_ID);
      rptComment.DataBind();
      // 댓글 총갯수 (BOARD_LIB.CommentList 메서드가 리턴한 DataTable 의 Rows.Count)
      // ==> 따로 생성하지 않았으므로 다음처럼 형변환 후 가져옴.
      // ((DataTable)rptComment.DataSource).Rows.Count
      // Label (<span>) 태그에 style 속성의 값을 color:blue 로 줌.
      lblCommentCount.Attributes.Add("style", "color:blue");
      lblCommentCount.Text = "<b>총" + ((DataTable)rptComment.DataSource).Rows.Count + "개의 댓글이 있습니다. </b>";
	}

  void btnRecommend_Click(object sender, EventArgs e)
  {
    if (Session["login_id"] == null)
    {
      string alert_str = "<script language=JavaScript> alert('추천하고 싶으면 로그인 먼저 하고 와');" +"</"+ "script>";
      ClientScript.RegisterStartupScript(typeof(Page), "alert", alert_str);
    }

    else
    {
      Board BOARD_LIB = new Board();
      if(RecommendFlag == 0){ // 이전에 추천을 한적이 없다.
        BOARD_LIB.Recommend((string)Session["login_id"],CATEGORY_ID, BOARD_ID);
        Page_Load();
      }
      else{ // 이전에 추천을 한적이 있다.
        BOARD_LIB.RecommendMinus((string)Session["login_id"],CATEGORY_ID, BOARD_ID);
        Page_Load();
      }
    }

  }

  void btnModify_Click(object sender, EventArgs e)
  {
    Response.Redirect(String.Format("board_write.aspx?c={0}&n={1}&page={2}&stype={3}&svalue={4}",
          CATEGORY_ID, BOARD_ID, NOW_PAGE, Request["stype"], Request["svalue"]));
  }

  void btnDelete_Click(object sender, EventArgs e)
  {
    Board BOARD_LIB = new Board();
    BOARD_LIB.Remove(CATEGORY_ID, BOARD_ID);

    Response.Redirect(String.Format("board_list.aspx?c={0}",CATEGORY_ID));
  }
</script>

<INCLUDE:TOP runat="server" />
<BOARD:TOP runat="server" />
<!-- ----------------------------------여기서부터 내용 ---------->
<div id="content">
<form runat="server">
<br><br>

  <h2>게시글 확인!</h2>
  <hr width="650" color="green">

  제목 : <ASP:Label id="lblTitle" runat="server" />
  <br><br>

  작성: <ASP:Label id="lblName" runat="server" />
  조회수 : <ASP:Label id="lblRead" runat="server" />
  추천 : <ASP:Label id="lblRecommend" runat="server" />
  <br>
  내용
  <br>
  <ASP:Label id="lblContent" runat="server" />
  <br>
  <br>
  <center>
    <ASP:Button id="btnRecommend" text="추천하기" onclick="btnRecommend_Click" runat="server" />
  </center>
  첨부파일 : <ASP:Label id="lblFile" runat="server" />

  <table>
    <tr id="trModifyDelete" visible="false" runat="server">
      <td>
        <ASP:Button id="btnModify" text="수정하기" onClick="btnModify_Click" runat="server" />
        <ASP:Button id="btnDelete" text="삭제하기" onClick="btnDelete_Click" runat="server" />
      </td>
    </tr>
  </table>
<!--------------- 댓글쓰기 -------------------->

<table width="600" id="tblCommentWrite" runat="server">
<tr>
  <td width="150">
  <ASP:Label id="lblWriter" runat="server" />
  </td>
  <td width="450">
  <ASP:TextBox id="txtComment" textmode="multiline" width="450" height="80" runat="server" />
  <ASP:Button id="btnCommentWrite" text="댓글쓰기" onclick="btnCommentWrite_Click" runat="server" />   
  </td>
</tr>

</table>



<!---------------- 댓글 목록 ------------------->
<table width="600">
  <tr>
    <td colspan="2" align="center">
      <ASP:Label id="lblCommentCount" runat="server" />
    </td>
  </tr>

  <ASP:Repeater id="rptComment" runat="server">

  <ItemTemplate>
    <tr height="80">
      <td width="150" bgcolor="#eeeeee">
        <%# Eval("user_name") %>

        <br>
        <font size="1"> <%# Eval("regdate") %> </font>
        
      </td>
      
      <td width="450">
        <%# Eval("content") %>
      </td>
    </tr>
  
  </ItemTemplate>
  </ASP:Repeater>
  </table>  
<br><br>
<a href="board_list.aspx?c=<%= CATEGORY_ID %>&stype=<%= Request["stype"] %>&svalue=<%= Request["svalue"] %>">리스트</a>
</div>


</form>



<!-- ----------------------------------내용 끝 ---------->
<INCLUDE:BOTTOM runat="server" />

