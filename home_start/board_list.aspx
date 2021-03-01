<%@ Page Trace="true" debug="true" %>
<%@ Register TagPrefix="INCLUDE" TagName="TOP" src="top.ascx" %>
<%@ Register TagPrefix="BOARD" TagName="TOP" src="board_top.ascx" %>
<%@ Register TagPrefix="INCLUDE" TagName="BOTTOM" src="bottom.ascx" %>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "Study" %>

<script language="C#" runat="server">
  string CATEGORY_ID;
  int TOTAL_COUNT = 0;
  int NOW_PAGE = 1;
  int PAGE_COUNT = 0;

  // 검색 관련 변수
  string STYPE, SVALUE;
  // 검색 중
  bool IsSearch = false;

  Board BOARD_LIB;

  void Page_Load(){
    //사용 : Board.List(string category)
    BOARD_LIB = new Board();

    CATEGORY_ID = Request["c"];

    STYPE = Request["stype"];
    SVALUE = Request["svalue"];

    // 검색 추가
    if(!String.IsNullOrEmpty(STYPE) && !String.IsNullOrEmpty(SVALUE)) IsSearch = true;
    // --------------

    
    //리턴 : DataTable
    DataTable dtList = null;
    
    if(!String.IsNullOrEmpty(Request["page"]))
      NOW_PAGE = Int32.Parse(Request["page"]);

    // 검색 추가 : 검색중이라면 검색결과 메서드 호출
    if(IsSearch)
    {      
      //검색 취소 버튼을 보여줌
      btnCancel.Visible = true;

      //컨트롤 매치
      lstType.SelectedValue = STYPE;
      txtSearch.Text = SVALUE;
    }

    // 리스트 가져오기
    dtList = BOARD_LIB.List(CATEGORY_ID, NOW_PAGE, STYPE, SVALUE);
    
    // 총 글 수 가져오기
    TOTAL_COUNT = BOARD_LIB.ListCount(CATEGORY_ID, STYPE, SVALUE);
    
    if(TOTAL_COUNT != 0)
    {
      //나누어서 페이지수를 구함
      PAGE_COUNT = TOTAL_COUNT / BOARD_LIB.PAGE_SIZE;

      // 나머지가 있다면 한페이지 더 필요함.
      if(TOTAL_COUNT % BOARD_LIB.PAGE_SIZE != 0)
        PAGE_COUNT++;
    }
    // 글수, 페이지 수 넣어주기
    lblPage.Text = String.Format("[{0}] 개의 글 (<b>{1}</b> / {2} Page)",TOTAL_COUNT, NOW_PAGE, PAGE_COUNT);

    // 좌측 페이지 이동
    lblPageMove1.Text = BOARD_LIB.PageGen1(NOW_PAGE,PAGE_COUNT,"page",
        String.Format("c={0}&stype={1}&svalue={2}", CATEGORY_ID, STYPE, SVALUE));

    // 우측 페이지 이동
    if(TOTAL_COUNT != 0)
    {
      lblPageMove2.Text = BOARD_LIB.PageGen2(NOW_PAGE,PAGE_COUNT,"board_list.aspx",
            String.Format("c={0}&stype={1}&svalue={2}", CATEGORY_ID, STYPE, SVALUE),
            "page",4);
    }
    else 
    {
      lblPageMove2.Text = "페이지 없음";
    }

    rptList.DataSource = dtList;
    rptList.DataBind();
  }  

  string ToCustomTime(object datetime)
  {
    if(datetime != null)
    {
      DateTime d = (DateTime)datetime;

      TimeSpan ts = DateTime.Now.Subtract(d);

      if(ts.Days == 0)
      {
        if(ts.Hours == 0) return String.Format("{0}분 전",ts.Minutes);
        else return String.Format("{0}시간 전",ts.Hours);
      }
      else
        return ((DateTime)datetime).ToString("yy-MM-dd");
    }
    else
    {
      return "(Error)";
    }
  }

  void rptList_Bound(object sender, RepeaterItemEventArgs e)
  {
    // 시작번호는 전체 갯수에서 현재 페이지의 시작을 구하면 됨 
    int VIRTUAL_NUM = TOTAL_COUNT - e.Item.ItemIndex - ((NOW_PAGE-1) * BOARD_LIB.PAGE_SIZE) ;

    ((Label)e.Item.FindControl("lblNum")).Text = VIRTUAL_NUM.ToString();
  }

  void btnSearch_Click(object sender, EventArgs e){
    bool IsChecked = true;

    // 검색어가 입력되었는지 체크하는 과정은 생략
    // 뭔가가 잘못되었다면 IsChecked 값을 false 로 변경

    if(IsChecked)
    {
      Response.Redirect(
        String.Format("board_list.aspx?c={0}&stype={1}&svalue={2}",
        CATEGORY_ID,
        lstType.SelectedValue,
        txtSearch.Text.Trim())
      );
    }
    //오류출력
    else
    {
      //생략
    }
  }

  void btnCancel_Click(object sender, EventArgs e){
    Response.Redirect("board_list.aspx?c="+CATEGORY_ID);
  }
  
  string CheckSearch(string src){
    // 검색모드이고 검색대상이 제목일 때
    if(IsSearch && STYPE.Equals("title"))
    {
      // 바꿔서 리턴
      return src.Replace(SVALUE, "<b>" + SVALUE + "</b>");
    }
    // 아니라면 그냥 원본을 리턴
    else return src;
  }
</script>

<INCLUDE:TOP runat="server" />
<BOARD:TOP runat="server" />

<div id="content">

<br><br>

  <center>

  <h2>게시판 목록</h2>
  <hr width="650" color="green">


  <table width="600">
  <tr>
    <td colspan="6" align="right">
    <ASP:Label id="lblPage" runat="server" text="[123]개의 글 (1 / 999 page)" />
    </td>
  </tr>

  <tr align="center" bgcolor="#abcdef">
    <td width="30">123</td>

    <td>제목</td>

    <td width="80">작성자</td>

    <td width="80">작성일시</td>

    <td width="35">조회</td>

    <td width="35">추천</td>
    
  </tr>


<ASP:Repeater id="rptList" runat="server" OnItemDataBound="rptList_Bound">
  <ItemTemplate>
  <tr align="center">
    <td width="30"><ASP:Label id="lblNum" runat="server" /></td>

    <td align="left">
      <a href=board_view.aspx?c=<%# CATEGORY_ID %>&page=<%# NOW_PAGE %>&n=<%#Eval("board_id")%>&stype=<%# STYPE %>&svalue=<%# SVALUE %>>
        <%# CheckSearch((string)Eval("title"))%>
      </a>
    </td>

    <td width="80"><%# Eval("user_name")%></td>

    <td width="100"><%# (ToCustomTime(Eval("regdate")))%></td>

    <td width="35"><%# Eval("readnum")%></td>

    <td width="35"><%# Eval("recommend")%></td>
  </tr>
  </ItemTemplate>
</ASP:Repeater>
  
</table>

<br><br>
<center>
  <form id="frm" runat="server">
    <ASP:DropDownList id="lstType" runat="server">
      <ASP:ListItem value="title" text="제목" />
      <ASP:ListItem value="title" text="내용" />
    </ASP:DropDownList>

    <ASP:TextBox id="txtSearch" runat="server" />
    <ASP:Button id="btnSearch" text="검색시작" runat="server" onclick="btnSearch_Click" />
    <ASP:Button id="btnCancel" text="검색취소" visible="false" runat="server" onclick="btnCancel_Click" />
  </form>
</center>

  <br><br>

  <a href="board_write.aspx?c=test">글쓰기</a>


<br>

<table width="600">
<tr bgcolor="#eeeeee">
<td width="50%">
  <ASP:Label id="lblPageMove1" runat="server">이전페이지 / 다음페이지</ASP:Label>
</td>

<td width="50%" align="right">
  <ASP:Label id="lblPageMove2" runat="server">[이전10] <b>1</b> 2 3 4 5 6 7 8 9 10 [다음10]</ASP:Label>
</td>
</tr>
</table>

<br><br>



</div>

<INCLUDE:BOTTOM runat="server" />

