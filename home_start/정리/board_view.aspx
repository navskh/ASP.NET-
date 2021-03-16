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

      if(CATEGORY_ID == "pims")
      {
        DataTable dtView = BOARD_LIB.Read_PIMS(CATEGORY_ID, BOARD_ID);
      }
      else 
      {
        //DataTable dtView = BOARD_LIB.Read(CATEGORY_ID, BOARD_ID);
      }

      DataRow row = dtView.Rows[0];

      

      lblTitle.Text = (string)ㄹ["title"];
      lblName.Text = String.Format("{0} ({1})", row["user_name"], row["regdate"]);
      
      
      if(CATEGORY_ID != "pims")
      {
        //lblRead.Text = row["readnum"].ToString();
        lblRecommend.Text = row["recommend"].ToString();
      }
      
      lblContent.Text = (string)row["content"];

/*      RecommendFlag = BOARD_LIB.RecommendCheck((string)Session["login_id"],BOARD_ID); 
      if(RecommendFlag == 1){
        btnRecommend.Text = "추천취소";
      }
      else btnRecommend.Text = "추천하기";
*/  


      if ((string)row["file_attach"] != "")
        lblFile.Text = String.Format("<a href='upload/{0}'>{1}</a>", row["file_attach"], row["file_attach"]);

      else lblFile.Text = "없음";

      // 처음 열었을 때
      if (!IsPostBack)
      {
        //CommentList();
        //BOARD_LIB.ReadUp(CATEGORY_ID, BOARD_ID);

        //lblRead.Text = (Int32.Parse(lblRead.Text)+1).ToString(); // 처음 열었을 때 조회수 맞춰줌.

        // 수정, 삭제 기능 활성화 체크
        if(!String.IsNullOrEmpty((string)Session["login_id"])){
          if((string)Session["login_id"] == "admin" ||(string)Session["login_id"] == (string)row["user_id"])
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
      MESSAGE = "<font class='text-danger' color=red> [!!] 댓글등록필요. </font>";
      // 상태관리 (ViewState) 로 인해 입력 내용이 남아있게 되므로 없애줌  
    }
    else
    {
      Board BOARD_LIB = new Board();
      BOARD_LIB.CommentWrite(BOARD_ID, (string)Session["login_id"], (string)Session["login_nick"], comment);

      MESSAGE = "<font class='text-info' color=blue> 댓글이 등록 되었습니다. </font>";
      txtComment.Text = "";

      CommentList();
    }

    //결과 메세지 출력
    lblCommentResult.Text = MESSAGE;
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
  
  void btnList_Click(object sender, EventArgs e)
  {
    Response.Redirect(String.Format("board_list.aspx?c={0}&stype={1}&svalue={2}",CATEGORY_ID,Request["stype"],Request["svalue"]));
  }
</script>

<INCLUDE:TOP runat="server" />
<BOARD:TOP runat="server" />
<!-- ----------------------------------여기서부터 내용 ---------->
<div id="content">
<form runat="server">
<br><br>
<center>
  <h2>게시글 확인!</h2>

  <br>

<form runat="server">
<table class="table">
  <tr> 
    <td class="table-primary">이름(아이디) </td>
    <td colspan="8"> <ASP:Label id="lblName" runat="server" /> </td>
  </tr>

  <tr>
    <td class="table-primary"> 서비스 명 </td>
    <td > <ASP:TextBox class="form-control2" placeholder="서비스명을 입력해주세요" id="txtServiceName" runat="server" /> </td>

    <td class="table-primary"> 서비스ID </td>
    <td > <ASP:TextBox class="form-control2" placeholder="서비스아이디를 입력해주세요" id="txtServiceID" runat="server" /> </td>

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
    <td colspan="3"> <ASP:Label id="lblTitle" runat="server" /> </td>
    <td class="table-primary"> 요청기한 </td>
    <td> <ASP:TextBox class="form-control2" placeholder="요청기한을 입력해주세요" id="txtDueDate" runat="server" /> </td>
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
    <td class="table-light" colspan="8" width="675.46"> 
      <ASP:Label id="lblContent" runat="server" style="word-wrap:break-word; white-space: pre-line; table-layout: fixed;" />
    </td>
  </tr>

  <tr>
    <td class="table-primary"> 첨부파일 </td>
    <td  colspan="7"> 
      <ASP:Label id="lblFile" runat="server" />
    </td>
  </tr>
  <tr> </tr>
  <tr>
    <td colspan="8" id="trModifyDelete" visible="false" runat="server" align="right"> 
        <ASP:Label id="lblError" runat="server" Text="" />
        <ASP:Button class="btn btn-success" id="btnModify" text="수정하기" onClick="btnModify_Click" runat="server" />
        <ASP:Button class="btn btn-danger" id="btnDelete" text="삭제하기" onClick="btnDelete_Click" runat="server" />
        <ASP:Button margin-left="auto" class="btn btn-info" id="btnRecommend" text="추천하기" onclick="btnRecommend_Click" runat="server" />
    </td>
  </tr>

  <tr>
    <td>
    
    </td>
  </tr>
</table>
  
</center>



<!---------------- 댓글 목록 ------------------->
<center>
<table border-top="3px solid #dee2e6">
  <tr>
    <td colspan="2" align="center">
      <ASP:Label id="lblCommentCount" runat="server" />
    </td>
  </tr>

  <ASP:Repeater id="rptComment" runat="server">
  <ItemTemplate>
    <tr height="80">
      <th class="table-success" style="padding:0 0 0 10" width="231.81">
        <%# Eval("user_name") %>
        <br>
        <font size="1"> <%# Eval("regdate") %> </font>
      </td>
      
      <td class="table-light" width="675.46">
        <font style="word-wrap:break-word; white-space: pre-line; table-layout: fixed;"> <%# Eval("content") %> </font>
      </td>
    </tr>
  
  </ItemTemplate>
  </ASP:Repeater>
  </table>  



<!--------------- 댓글쓰기 -------------------->
  <br>
  <table id="tblCommentWrite" runat="server">
  <tr>
    <th class="table-info" width="231.81" style="padding:0 0 0 10">
      <ASP:Label id="lblWriter" runat="server" />
    </th>

      <td width="675.46">
      <ASP:TextBox class="form-control" id="txtComment" textmode="multiline" width="675.46" height="200" runat="server" />
      </td>
  </tr>
  <tr>
      <td colspan="2" align="right">
      <ASP:Label id="lblCommentResult" runat="server" />
      <ASP:Button class="btn btn-primary" id="btnCommentWrite" text="댓글쓰기" onclick="btnCommentWrite_Click" runat="server" />   
      </td>
  </tr>
</table>

</center>

<br>
<center>
<ASP:Button id="btnList" class="btn btn-warning" runat="server" text="리스트로" OnClick="btnList_Click"/>
</center>
</div>


</form>


<!-- ----------------------------------내용 끝 ---------->
<INCLUDE:BOTTOM runat="server" />

