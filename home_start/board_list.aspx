<%@ Register TagPrefix="INCLUDE" TagName="TOP" src="top.ascx" %>
<%@ Register TagPrefix="BOARD" TagName="TOP" src="board_top.ascx" %>
<%@ Register TagPrefix="INCLUDE" TagName="BOTTOM" src="bottom.ascx" %>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "Study" %>
<%@ Page Language="C#" Debug="true" %>

<script language="C#" runat="server">
  string CATEGORY_ID;
  int TOTAL_COUNT = 0;
  int NOW_PAGE = 1;
  int PAGE_COUNT = 0;
  int PAGE_BLOCK = 0;
  int NOW_BLOCK = 0;

  // 검색 관련 변수
  string STYPE, SVALUE;
  // 검색 중임을 알려주는 FLAG
  bool IsSearch = false;

  Board BOARD_LIB;
  Board BOARD_COMMENT;
  
  void Page_Load(){
    BOARD_LIB = new Board();
    
    CATEGORY_ID = Request["c"];

    // 검색 시 
    STYPE = Request["stype"];
    SVALUE = Request["svalue"];

    // 검색 추가
    if(!String.IsNullOrEmpty(STYPE) && !String.IsNullOrEmpty(SVALUE)) IsSearch = true;
    
    //리턴 : DataTable
    DataTable dtList = null;
    
    // 페이징을 위한 소스
    if(!String.IsNullOrEmpty(Request["page"]))
      NOW_PAGE = Int32.Parse(Request["page"]);

    // 검색 추가 : 검색중이라면 검색결과 메서드 호출
    if(IsSearch)
    {      
      //검색 취소 버튼을 보여줌
      btnCancel.Visible = true;

      if(!IsPostBack){
      //컨트롤 매치
      lstType.SelectedValue = STYPE;
      txtSearch.Text = SVALUE;
      }
    }

    // 포토 게시판의 경우 한페이지에 12개씩 들억가게 만들었음.
    //if(CATEGORY_ID.ToLower().Equals("photo"))
    //  BOARD_LIB.PAGE_SIZE = 12;


    // 리스트 가져오기
    if(CATEGORY_ID.ToLower().Equals("pims")) 
    {
      dtList = BOARD_LIB.List_PIMS(NOW_PAGE, STYPE, SVALUE); // SELECT 로 리스트를 가져옴 (검색 시 검색키워드 사용하여 리스트 가져옴)
      TOTAL_COUNT = BOARD_LIB.ListCount_PIMS(CATEGORY_ID, STYPE, SVALUE); // 전체 카운트 확인 SELECT COUNT 사용
    }
  
    else // 일단 사용 안함.
    {
      dtList = BOARD_LIB.List(CATEGORY_ID, NOW_PAGE, STYPE, SVALUE);
      TOTAL_COUNT = BOARD_LIB.ListCount(CATEGORY_ID, STYPE, SVALUE);
    }
  
    // 총 글 수 가져오기
    if(TOTAL_COUNT != 0)
    {
      //나누어서 페이지수를 구함
      PAGE_COUNT = TOTAL_COUNT / BOARD_LIB.PAGE_SIZE;
      
      // 나머지가 있다면 한페이지 더 필요함.
      if(TOTAL_COUNT % BOARD_LIB.PAGE_SIZE != 0)
        PAGE_COUNT++;

      
      PAGE_BLOCK = PAGE_COUNT/10;
      if(PAGE_COUNT%10 != 0) PAGE_BLOCK++;
      NOW_BLOCK = NOW_PAGE/10;
      if(NOW_PAGE%10 != 0) NOW_BLOCK++;

      lblTotalPageInfo.Text = String.Format("총 {0} 페이지가 있습니다.", PAGE_COUNT);
    }
    // 글수, 페이지 수 넣어주기
    lblPage.Text = String.Format("[{0}] 개의 글 (<b>{1}</b> / {2} Page)",TOTAL_COUNT, NOW_PAGE, PAGE_COUNT);
    lblPage2.Text = String.Format("[{0}] 개의 글 (<b>{1}</b> / {2} Page)",TOTAL_COUNT, NOW_PAGE, PAGE_COUNT);

    // 페이지가 1개 이하인 경우 한칸씩 이동 칸 제거
    if(PAGE_COUNT<=1) lblPageMove1.Visible = false;
    
    else
    {
      // 한칸씩 페이지 이동
      lblPageMove1.Text = BOARD_LIB.PageGen1(NOW_PAGE,PAGE_COUNT,"page",
        String.Format("c={0}&stype={1}&svalue={2}", CATEGORY_ID, STYPE, SVALUE));
    }

    // 열칸씩 생기는 페이지 이동 탭
    if(TOTAL_COUNT != 0)
    {
      lblPageMove2.Text = BOARD_LIB.PageGen2(NOW_PAGE,PAGE_COUNT,"board_list.aspx",
            String.Format("c={0}&stype={1}&svalue={2}", CATEGORY_ID, STYPE, SVALUE),
            "page",10);
    }
    else 
    {
      lblPageMove2.Visible = false;
    }

    if(NOW_BLOCK == 1)
    {
      if(PAGE_BLOCK == 1) {
        lblPageMove3.Visible = false;
        lblTotalPageInfo.Visible = false;
      }

      else{
        lblPageMove3.Text = String.Format("<td> <a class=page-link2-disabled>이전 10페이지 이동 </a> </td> " +
        "<td> <a class=page-link2 href=board_list.aspx?c=pims&stype={0}&svalue={1}&page={2}>다음 10페이지 이동 </a> </td>"
        , STYPE, SVALUE, (NOW_PAGE/10+1)*10+1);
      }
    }
    else if(NOW_BLOCK == PAGE_BLOCK)
    {
      lblPageMove3.Text = String.Format("<td> <a class=page-link2 href=board_list.aspx?c=pims&stype={0}&svalue={1}&page={2}>이전 10페이지 이동 </a> </td> " +
      "<td> <a class=page-link2-disabled>다음 10페이지 이동 </a> </td>"
      ,STYPE, SVALUE, (NOW_PAGE/10-1)*10+1);
    }
    else
    {
      lblPageMove3.Text = String.Format("<td> <a class=page-link2 href=board_list.aspx?c=pims&stype={0}&svalue={1}&page={2}>이전 10페이지 이동 </a> </td> " +
      "<td> <a class=page-link2 href=board_list.aspx?c=pims&stype={3}&svalue={4}&page={5}>다음 10페이지 이동 </a> </td>"
      ,STYPE, SVALUE, (NOW_PAGE/10-1)*10+1, STYPE, SVALUE, (NOW_PAGE/10+1)*10+1);
    }


    // ---------- 나중에 공부 정리 탭 사용하기 위해 PLACEHOLDER로 구분함.
    if(CATEGORY_ID.ToLower().Equals("pims"))
    {
      phBoard2.Visible = false;
      rptList.DataSource = dtList;
      rptList.DataBind();
    }
    else if(CATEGORY_ID.ToLower().Equals("study"))
    {
      phBoard1.Visible = false;
      rptList_study.DataSource = dtList;
      rptList_study.DataBind();
    }
    else  // 만약에 이상한 카테고리가 넘어올 경우 카테고리 없다는 메세지 출력
    {
      Response.Redirect("./board_categorymsg.aspx");
    }
  }  

  string ToCustomTime(object datetime) // 시간을 하루가 지나기 전이면 ..시간전, 한시간이 지나기 전이면 ..분전으로 표시
  {
    if(datetime != null)
    {
      DateTime d = (DateTime)datetime; // DateTime 형식으로 저장

      TimeSpan ts = DateTime.Now.Subtract(d); // TimeSpan : 지금으로 부터 얼마나 지났는지를 표시

      if(ts.Days == 0) // 하루가 안지났으면
      {
        if(ts.Hours == 0) return String.Format("{0}분 전",ts.Minutes); // 한시간이 안지났으면
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

  void rptList_Bound(object sender, RepeaterItemEventArgs e) // 리피터 데이터 바인딩 할 때 처리해주는 정보
  {
    // 시작번호는 전체 갯수에서 현재 페이지의 시작을 구하면 됨 
    int VIRTUAL_NUM = TOTAL_COUNT - e.Item.ItemIndex - ((NOW_PAGE-1) * BOARD_LIB.PAGE_SIZE) ;

    // 표 라벨 번호
    ((Label)e.Item.FindControl("lblNum")).Text = VIRTUAL_NUM.ToString();

    // 요청 상태에 따라 class를 다르게 하여 색상 변경하게 수정
    if(((Label)e.Item.FindControl("lblcondition")).Text == "불가")
    {
      ((Label)e.Item.FindControl("lblTR_Open")).Text = "<tr class='table-danger'>";
    }
    else if(((Label)e.Item.FindControl("lblcondition")).Text == "처리중")
    ((Label)e.Item.FindControl("lblTR_Open")).Text = "<tr class='table-light'>";
    else if(((Label)e.Item.FindControl("lblcondition")).Text == "지연")
    ((Label)e.Item.FindControl("lblTR_Open")).Text = "<tr class='table-warning'>";
    else if(((Label)e.Item.FindControl("lblcondition")).Text == "완료")
    ((Label)e.Item.FindControl("lblTR_Open")).Text = "<tr class='table-success'>";
    else
    ((Label)e.Item.FindControl("lblTR_Open")).Text = "<tr>";
  }

  void rptList_study_Bound(object sender, RepeaterItemEventArgs e)
  {
    int VIRTUAL_NUM = TOTAL_COUNT - e.Item.ItemIndex - ((NOW_PAGE-1) * BOARD_LIB.PAGE_SIZE) ;
    ((Label)e.Item.FindControl("lblNum")).Text = VIRTUAL_NUM.ToString();
  }

  void btnSearch_Click(object sender, EventArgs e){ // 검색 버튼 클릭 시 stype과 svalue를 포함시켜 get방식으로 board_list로 넘겨줌
    bool IsChecked = true;

    if(IsChecked)
    {
      Response.Redirect(
        String.Format("board_list.aspx?c={0}&stype={1}&svalue={2}",
        CATEGORY_ID,
        lstType.SelectedValue,
        txtSearch.Text.Trim())
      );
    }

    //오류출력 (생략)
    else
    {

    }
  }

  void btnCancel_Click(object sender, EventArgs e){ // 검색 취소 시 다시 목록 조회로 돌아감
    Response.Redirect("board_list.aspx?c="+CATEGORY_ID);
  }
  
  string CheckSearch(string src){ // 검색 중일 때 검색한 단어를 파란색으로 칠해줘서 강조시켜주는 함수
    // 검색모드이고 검색대상이 제목일 때
    if(IsSearch && STYPE.Equals("title"))
    {
      // 바꿔서 리턴
      return src.Replace(SVALUE, "<b style=" + "color:blue>" + SVALUE + "</b>");
    }
    // 아니라면 그냥 원본을 리턴
    else return src;
  }

  string CommentCount(int b_id)
  {
    BOARD_COMMENT = new Board();
    int COMMENT_NUM = BOARD_COMMENT.CommentAmount(b_id);

    if(COMMENT_NUM > 0) return "["+COMMENT_NUM.ToString()+"]";

    else return "";
  }


  void btnWriteboard_Click(object sender, EventArgs e) // 글쓰기 버튼 클릭 시 동작
  {
    // PIMS 요청 카테고리는 pims. 이전에 게시판 탭이 여러개 있었을 때 사용된 정보
    CATEGORY_ID = Request["c"];
    if(CATEGORY_ID == "study")
    {
      Response.Redirect("board_write_study.aspx?c=study");
    }


    string USER_ID = (string)Session["login_id"]; 
    
    // 로그인 해야 글 작성 가능하게 막아둠.
    if(String.IsNullOrEmpty(USER_ID)) 
    {
      string alert_str = "<script language=JavaScript> alert('글을 작성하려면 로그인하세요.');" +"</"+ "script>";
      ClientScript.RegisterStartupScript(typeof(Page), "alert", alert_str);
    }

    // 운영자만 글 작성할 수 있게 막아둠.
    else{
      DataTable dtUser = BOARD_LIB.Read_User(USER_ID);
      DataRow user = dtUser.Rows[0];
      string user_type = (string)user["user_type"];

      if(user_type == "Manger")
      {
        Response.Redirect("board_write.aspx?c=pims");  
      }
      else{ 
        string alert_str = "<script language=JavaScript> alert('운영자만 요청글을 작성할 수 있습니다.');" +"</"+ "script>";
        ClientScript.RegisterStartupScript(typeof(Page), "alert", alert_str);
      }
    }
  }
</script>

<INCLUDE:TOP runat="server" />
<BOARD:TOP runat="server" />

<div id="content">
<br><br>

<!-- PIMS 업무 요청 영역 시작-->
<ASP:PlaceHolder id="phBoard1" runat="server">
  <center>
  <h2><b>PIMS 요청사항 목록</b></h2>

  <table class="table table-hover">

  <tr>
    <th colspan="6" align="right">
      <!-- [총 글수] (현재페이지/전체페이지) -->
    <ASP:Label id="lblPage" runat="server" text="[123]개의 글 (1 / 999 page)" />
    </th>
  </tr>  

  <tr  class="table-info">
    <td align="center">번호</td>
    <td width=400 align="center">제목</td>
    <td align="center"> 개발담당자 </td>
    <td > 요청상태 </td>
    <td> 우선순위 </td>
    <td>작성자</td>
    <td>작성일시</td>   
  </tr>

  <!-- 리피터 사용하여 데이터 바인딩하여 DB 정보 출력 -->
  <ASP:Repeater id="rptList" runat="server" OnItemDataBound="rptList_Bound">
  <ItemTemplate>
    <!--요청 상태에 맞게 색 입히기 위해 클래스 부여하여 tr 태그 label로 오픈-->
    <ASP:Label id="lblTR_Open" runat="server" /> 

    <!-- 표 가장 왼쪽 순차적으로 뜨는 번호 -->
    <td align="center"><ASP:Label id="lblNum" runat="server" /></td>

    <td align="center">
      <a class="table-link" 
      href=pims_board_view.aspx?c=<%# CATEGORY_ID %>&page=<%# NOW_PAGE %>&n=<%#Eval("board_id")%>&stype=<%# STYPE %>&svalue=<%# SVALUE %>>
        <%# CheckSearch((string)Eval("title"))%> <%# CommentCount((int)Eval("board_id"))%>
      </a>
    </td>
    <td align="center"> <%# Eval("DeveloperID")%> </td>
    <!-- 요청 상태 데이터 바인딩 할 때 받아와서 색 입힐 때 사용위해 변수로 설정-->
    <td> <ASP:Label id="lblcondition" runat="server" Text=<%# Eval("condition")%>/> </td>
    <td> <%# Eval("Due_Date")%> </td>

    <td ><%# Eval("user_name")%></td>

    <td><%# (ToCustomTime(Eval("regdate")))%></td>
  </tr>  
  </ItemTemplate>
  </ASP:Repeater>
  </table>
</ASP:PlaceHolder>
<!-- PIMS 업무 요청 영역 끝-->

<!-- 교육 내용 영역 시작 (추후 수정 예정)-->
<ASP:PlaceHolder id="phBoard2" runat="server">
  <center>

  <h2><b>교육 내용 정리</b></h2>


  <table class="table table-hover">

  <tr>
    <th colspan="6" align="right">
    <ASP:Label id="lblPage2" runat="server" text="[123]개의 글 (1 / 999 page)" />
    </th>
  </tr>  

  <tr align="center" class="table-info">
    <td>번호</td>

    <td width="45%">제목</td>

    <td>작성자</td>

    <td>작성일시</td>

    <td>조회</td>

    <td>추천</td>
    
  </tr>


  <ASP:Repeater id="rptList_study" runat="server" OnItemDataBound="rptList_study_Bound">
  <ItemTemplate>
  <tr align="center">
    <td width="10%"><ASP:Label id="lblNum" runat="server" /></td>

    <td>
      <a class="table-link" 
      href=board_view.aspx?c=<%# CATEGORY_ID %>&page=<%# NOW_PAGE %>&n=<%#Eval("board_id")%>&stype=<%# STYPE %>&svalue=<%# SVALUE %>>
        <%# CheckSearch((string)Eval("title"))%>
      </a>
    </td>

    <td ><%# Eval("user_name")%></td>

    <td><%# (ToCustomTime(Eval("regdate")))%></td>

    <td ><%# Eval("readnum")%></td>
    <td ><%# Eval("recommend")%></td>
  </tr>
  
  </ItemTemplate>
  </ASP:Repeater>
  </table>
</ASP:PlaceHolder>
<!-- 교육 내용 영역 끝 -->

<!-- 검색 필드 제목, 내용 필터를 선택한 후 검색-->
<center>
  <form runat="server">
  <table>
    <tr>
      <td width="150"> <ASP:DropDownList class="form-control" id="lstType" runat="server">
        <ASP:ListItem value="title" text="제목" />
        <ASP:ListItem value="content" text="내용" /> 
      </ASP:DropDownList>  </td>
      <td width="250"> <ASP:TextBox id="txtSearch" class="form-control" runat="server" /> </td>
      <td> <ASP:Button class="btn btn-primary" id="btnSearch" text="검색시작" runat="server" onclick="btnSearch_Click" /> </td>
      <td><ASP:Button class="btn btn-primary" id="btnCancel" text="검색취소" visible="false" runat="server" onclick="btnCancel_Click" /> </td>
    </tr>
  </table>  
</center>

  <ASP:Button class="btn btn-info" runat="server" id="btnWrite_board" text="글쓰기" onclick="btnWriteboard_Click" />
  </form>
<br>
<br>

<!--페이지 한칸씩 이동 탭-->
<ASP:Label class="pagination2" id="lblPageMove1" runat="server">이전페이지 / 다음페이지</ASP:Label>

<!--페이지 이동 탭-->
<table>
  <tr>
    <td>
    <ul class="pagination pagination-lg">
    <li class="page-item">
      <ASP:Label id="lblPageMove2" class="page-item" runat="server">[이전10] <b>1</b> 2 3 4 5 6 7 8 9 10 [다음10]</ASP:Label>
    </li>
    </ul>
    </td>
  </tr>
</table>

<table text-align="center">
  <tr>
    <td colspan="2" align="center">
    <ASP:Label id="lblTotalPageInfo" class="text-info" runat="server"/>
    </td>
  </tr>
  <tr>
    <ASP:Label id="lblPageMove3" class="page-item" runat="server"> ◁ 이전 10페이지 / 다음 10페이지 ▷ </ASP:Label>
  </tr>
</table>
<br><br>

</div>

<INCLUDE:BOTTOM runat="server" />

