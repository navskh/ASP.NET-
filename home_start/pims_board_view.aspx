<%@ Register TagPrefix="INCLUDE" TagName="TOP" src="top.ascx" %>
<%@ Register TagPrefix="BOARD" TagName="TOP" src="board_top.ascx" %>

<%@ Register TagPrefix="INCLUDE" TagName="BOTTOM" src="bottom.ascx" %>
<%@ Page Language="C#" Debug="true" %>
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
      // 로그인이 안되어 있으면 댓글 쓰기 영역 없애기
      if (Session["login_id"] == null)
        tblCommentWrite.Visible = false;
      //로그인 되었으면 작성자 Label 넣기
      else 
      lblWriter.Text = (string)Session["login_nick"] + 
      "(" + (string)Session["user_type"] + ")";
      
      
      CATEGORY_ID = Request["c"];
      BOARD_ID = Int32.Parse(Request["n"]);
      Board BOARD_LIB = new Board();
      DataTable dtView = BOARD_LIB.Read_PIMS(CATEGORY_ID, BOARD_ID);
      DataRow row = dtView.Rows[0];

      Board BOARD_USER = new Board();

      string user_type = "";

      if (Session["login_id"] == null)
      {
        user_type = "none";
      }

      else
      {
        DataTable dtUser = BOARD_USER.Read_User((string)Session["login_id"]);
        DataRow user = dtUser.Rows[0];
        user_type = (string)user["user_type"];
      }
      /*
      if(user_type == "Manger")
      {
        lblcondition.Visible = true;
        lblcondition.Text = (string)row["condition"];
        contentCondition.Visible = false;
      }

      else if(user_type == "PD")
      {
        lblcondition.Visible = false;
        //lblcondition.Text = (string)row["condition"];
        contentCondition.Visible = true;
      }

      else
      {
        lblcondition.Visible = true;
        lblcondition.Text = (string)row["condition"];
        contentCondition.Visible = false;
      }*/

      lblServiceID.Text = (string)row["UnivServiceID"];
      lblServiceName.Text = (string)row["ServiceName"];
      lblDeveloper.Text = (string)row["DeveloperID"];

      lblTitle.Text = (string)row["title"];
      lblDueDate.Text = (string)row["Due_Date"];
      lblBoard_Type.Text = (string)row["Board_Type"];

      lblName.Text = String.Format("{0} ({1})", row["user_name"], row["regdate"]);
      lblContent.Text = (string)row["content"];
      
      if ((string)row["file_attach"] != "")
        lblFile.Text = String.Format("<a href='upload/{0}'>{1}</a>", row["file_attach"], row["file_attach"]);

      else lblFile.Text = "없음";

      // 처음 열었을 때
      if (!IsPostBack)
      {
        CommentList();
        // 수정, 삭제 기능 활성화 체크
        if(!String.IsNullOrEmpty((string)Session["login_id"])){
          if((string)Session["login_id"] == "admin" ||(string)Session["login_id"] == (string)row["user_id"])
          {
            trModifyDelete.Visible = true;
          }
        }

        if((string)row["condition"] == "접수")
        {
          if(user_type == "Manger")
          {
            lblcondition.Visible = true;
            lblcondition.Text = (string)row["condition"];
            contentCondition.Visible = false;
          }
          else if(user_type == "PD")
          {
            lblcondition.Visible = false;
            //lblcondition.Text = (string)row["condition"];
            contentCondition.Visible = true;
          }
          else
          {
            lblcondition.Visible = true;
            lblcondition.Text = (string)row["condition"];
            contentCondition.Visible = false;
          }
        }

        else
        {
          if((string)Session["login_nick"] == lblDeveloper.Text) 
          {
            this.contentCondition.Items[0].Enabled = false;
            this.contentCondition.Items[1].Enabled = true;
            this.contentCondition.Items[2].Enabled = true;
            this.contentCondition.Items[3].Enabled = true;
            this.contentCondition.Items[4].Enabled = true;

            switch((string)row["condition"]){
              case "처리중":             
                this.contentCondition.SelectedIndex = 1;
                break;
              case "완료":             
                this.contentCondition.SelectedIndex = 2;
                break;
              case "지연":             
                this.contentCondition.SelectedIndex = 3;
                break;
              case "불가":             
                this.contentCondition.SelectedIndex = 4;
                break;
            }    
          }
          else
          {
            lblcondition.Visible = true;
            lblcondition.Text = (string)row["condition"];
            contentCondition.Visible = false;
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



  void btnModify_Click(object sender, EventArgs e)
  {
    Response.Redirect(String.Format("board_write.aspx?c={0}&n={1}&page={2}&stype={3}&svalue={4}",
          CATEGORY_ID, BOARD_ID, NOW_PAGE, Request["stype"], Request["svalue"]));
  }

  void btnDelete_Click(object sender, EventArgs e)
  {
    Board BOARD_LIB = new Board();
    BOARD_LIB.Remove_PIMS(CATEGORY_ID, BOARD_ID);

    Response.Redirect(String.Format("board_list.aspx?c={0}",CATEGORY_ID));
  }
  
  void btnList_Click(object sender, EventArgs e)
  {
//    Response.Redirect(String.Format("board_list.aspx?c={0}&stype={1}&svalue={2}",CATEGORY_ID,Request["stype"],Request["svalue"]));
    Response.Redirect(String.Format("board_list.aspx?c={0}&page={1}&stype={2}&svalue={3}",
          CATEGORY_ID, NOW_PAGE, Request["stype"], Request["svalue"]));
  }

  void condition_change(object sender, EventArgs e)
  {
    this.contentCondition.Items[0].Enabled = false;
    this.contentCondition.Items[1].Enabled = true;
    this.contentCondition.Items[2].Enabled = true;
    this.contentCondition.Items[3].Enabled = true;
    this.contentCondition.Items[4].Enabled = true;

    if(this.contentCondition.SelectedValue == "inprogress")
    { 
      Board BOARD_LIB = new Board();
      
      string alert_str = "<script language=JavaScript> alert('요청을 처리합니다.');" +"</"+ "script>";
      ClientScript.RegisterStartupScript(typeof(Page), "alert", alert_str);   
      lblDeveloper.Text = (string)Session["login_nick"];
      BOARD_LIB.Update_condition(lblDeveloper.Text, "처리중", BOARD_ID);

    }
    else if(this.contentCondition.SelectedValue == "finish")
    {
      Board BOARD_LIB = new Board();
      BOARD_LIB.Update_condition(lblDeveloper.Text, "완료", BOARD_ID);
      
      this.contentCondition.SelectedIndex = 2;
    }

    else if(this.contentCondition.SelectedValue == "cannot")
    {
      Board BOARD_LIB = new Board();
      BOARD_LIB.Update_condition(lblDeveloper.Text, "불가", BOARD_ID);

      this.contentCondition.SelectedIndex = 4;
    }
    
    else if(this.contentCondition.SelectedValue == "delay")
    {
      Board BOARD_LIB = new Board();
      BOARD_LIB.Update_condition(lblDeveloper.Text, "지연", BOARD_ID);

      this.contentCondition.SelectedIndex = 3;
    }
  }

  void rptComment_Bound(object sender, RepeaterItemEventArgs e)
  {
    string user_type = ((Label)e.Item.FindControl("lblUserType")).Text;
    string TH_open = "";

    if(user_type == "Manger")
    {
      user_type = "(운영자)";
      TH_open = "<th class = table-warning width=216>";
    }
    else if(user_type == "PD")
    {
      user_type = "(개발자)";
      TH_open = "<th class = table-info width=216>";
    }
    else
    {
      user_type = "(미정)";
      TH_open = "<th class = table-light width=216>";
    }

    ((Label)e.Item.FindControl("lblUserType")).Text = user_type;
    ((Label)e.Item.FindControl("lblTH_Open")).Text = TH_open;
  }
</script>

<INCLUDE:TOP runat="server" />
<BOARD:TOP runat="server" />
<!-- ----------------------------------여기서부터 내용 ---------->
<div id="content">
<form runat="server">
<br><br>
<center>
  <h2> <b> 요청사항 확인 </b> </h2>

  <br>

<table class="table">
  <tr> 
    <td class="table-primary">이름(작성일자) </td>
    <td colspan="8"> <ASP:Label id="lblName" runat="server" /> </td>
  </tr>

  <tr>
    <td class="table-primary"> 서비스 명 </td>
    <td > <ASP:Label id="lblServiceName" runat="server" /> </td>

    <td class="table-primary"> 서비스ID </td>
    <td > <ASP:Label id="lblServiceID" runat="server" /> </td>

    <td class="table-primary"> 개발 담당자 </td>
    <td > <ASP:Label id="lblDeveloper" runat="server"/> </td>

    <td class="table-primary"> 요청상태 </td>
    <td> 
      <ASP:Label id="lblcondition" runat="server" />
      <ASP:DropDownList class="form-control2" id="contentCondition" OnSelectedIndexChanged="condition_change" AutoPostBack="true" runat="server">
        <ASP:ListItem Value="ready" text="접수" />
        <ASP:ListItem Value="inprogress" text="처리중" /> 
        <ASP:ListItem Value="finish" Enabled="false" text="완료" /> 
        <ASP:ListItem Value="delay"  Enabled="false" text="지연" /> 
        <ASP:ListItem Value="cannot" Enabled="false" text="불가" />  
      </ASP:DropDownList>
    </td>
  </tr>

  <tr>
    <td class="table-primary" > 제목 </td>
    <td colspan="3"> <ASP:Label id="lblTitle" runat="server" /> </td>
    <td class="table-primary"> 우선순위 </td>
    <td> <ASP:Label id="lblDueDate" runat="server" /> </td>
    <td class="table-primary"> 대분류 </td>
    <td> <ASP:Label id="lblBoard_Type" runat="server" /> </td>
  </tr>

  <tr> 
    <td class="table-primary"> 내용 </td>
    <td class="table-light" colspan="8" width="675.46"> 
      <ASP:Label id="lblContent" runat="server" style="word-wrap:break-word; white-space: pre-line; table-layout: fixed;" />
    </td>
  </tr>

  <tr>
    <td class="table-primary"> 첨부파일 </td>
    <td  colspan="7"> <ASP:Label id="lblFile" runat="server" /> </td>
  </tr>
  <tr>
    <td colspan="8" id="trModifyDelete" visible="false" runat="server" align="right"> 
        <ASP:Label id="lblError" runat="server" Text="" />
        <ASP:Button class="btn btn-success" id="btnModify" text="수정하기" onClick="btnModify_Click" runat="server" />
        <ASP:Button class="btn btn-danger" id="btnDelete" text="삭제하기" onClick="btnDelete_Click" runat="server" />
    </td>
  </tr>
</table>
  
</center>

<!---------------- 댓글 목록 ------------------->
<center>
<table class="table" border-top="3px solid #dee2e6">
  <tr>
    <td colspan="2" align="center">
      <ASP:Label id="lblCommentCount" runat="server" />
    </td>
  </tr>

  <ASP:Repeater id="rptComment" runat="server" OnItemDataBound="rptComment_Bound">
  <ItemTemplate>
    <tr height="80">
      <ASP:Label id="lblTH_Open" runat="server"/>
        <%# Eval("user_name") %> <ASP:Label id="lblUserType" runat="server" Text=<%# Eval("user_type") %>/>
        <br>
        <font size="1"> <%# Eval("regdate") %> </font>
      </td>
      
      <td>
        <font style="word-wrap:break-word; white-space: pre-line; table-layout: fixed;"> <%# Eval("content") %> </font>
      </td>
    </tr>
  
  </ItemTemplate>
  </ASP:Repeater>
  </table>  
  </center>


<!--------------- 댓글쓰기 -------------------->
  <br>
  <center>
  <table class="table" id="tblCommentWrite" runat="server">
  <tr>
    <th colspan="2">
      <h3><b> 댓글작성 </b> </h3>
    </th>
  </tr>
  <tr>
    <th class="table-success" width="216">
      <ASP:Label id="lblWriter" runat="server" />
    </th>
    <td>
      <ASP:TextBox class="form-control2" id="txtComment" textmode="multiline" height="200" runat="server" />
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

