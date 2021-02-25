<%@ Register TagPrefix="INCLUDE" TagName="TOP" src="top.ascx" %>
<%@ Register TagPrefix="INCLUDE" TagName="BOTTOM" src="bottom.ascx" %>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "Study" %>

<script language="C#" runat="server">
  string CATEGORY_ID;
  void Page_Load(){
    CATEGORY_ID = Request["c"];

    //사용 : Board.List(string category)
    Board BOARD_LIB = new Board();
    //리턴 : DataTable
    DataTable dtList = BOARD_LIB.List(CATEGORY_ID);

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
</script>

<INCLUDE:TOP runat="server" />

<div id="content">

<br><br>

  <center>

  <h2>게시판 목록</h2>
  <hr width="650" color="green">


  <table width="600">

  <tr align="center">
    <td width="30">123</td>

    <td>제목</td>

    <td width="80">작성자</td>

    <td width="80">작성일시</td>

    <td width="35">조회</td>

    <td width="35">추천</td>
    
  </tr>


<ASP:Repeater id="rptList" runat="server">
  <ItemTemplate>
  <tr align="center">
    <td width="30"> <%# Eval("board_id")%> </td>

    <td align="left">
      <a href=board_view.aspx?c=<%# CATEGORY_ID %>&n=<%#Eval("board_id")%>>
        <%# Eval("title")%>
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


  <br>

  <a href="board_write.aspx?c=test">글쓰기</a>

  </center>


</div>

<INCLUDE:BOTTOM runat="server" />

