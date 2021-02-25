<%@ Register TagPrefix="INCLUDE" TagName="TOP" src="top.ascx" %>
<%@ Register TagPrefix="INCLUDE" TagName="BOTTOM" src="bottom.ascx" %>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "Study" %>


<INCLUDE:TOP runat="server" />
<!-- ----------------------------------여기서부터 내용 ---------->

<script language="C#" runat="server">
  string CATEGORY_ID;
  int BOARD_ID;

    void Page_Load(){
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

      if((string)row["file_attach"] != "")
      lblFile.Text = String.Format("<a href=upload/{0}>{1}</a>",row["file_attach"],row["file_attach"]);
      else lblFile.Text = "없음";
    }

</script>

<div id="content">

<br><br>



  <h2>게시글 확인!</h2>
  <hr width="650" color="green">

  제목 : <ASP:Label id="lblTitle" runat="server" />
  <br>

  작성: <ASP:Label id="lblName" runat="server" />
  조회수 : <ASP:Label id="lblRead" runat="server" />
  추천 : <ASP:Label id="lblRecommend" runat="server" />
  <br>
  내용
  <br>
  <ASP:Label id="lblContent" runat="server" />
  <br>
  첨부파일 : <ASP:Label id="lblFile" runat="server" />

</div>


<!-- ----------------------------------내용 끝 ---------->
<INCLUDE:BOTTOM runat="server" />

