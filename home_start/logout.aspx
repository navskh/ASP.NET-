<%@ Register TagPrefix="INCLUDE" TagName="TOP" src="top.ascx" %>
<%@ Register TagPrefix="INCLUDE" TagName="BOTTOM" src="bottom.ascx" %>

<script language="C#" runat="server">
void Page_Load()
{
  if (Session["login_id"] != null)
  {
      Session.Abandon();
      Response.Redirect("logout.aspx");
  }
}
</script>

<INCLUDE:TOP runat="server" />

<!--------------------------- 여기서부터 내용 ------>
<div id="content">
<center>
성공적으로 로그아웃 되었습니다!
</center>
</div>
<!-- 내용끝 ---------------------------------------->

<INCLUDE:BOTTOM runat="server" />
