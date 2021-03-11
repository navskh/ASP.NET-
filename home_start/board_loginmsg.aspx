<%@ Register TagPrefix="INCLUDE" TagName="TOP" src="top.ascx" %>
<%@ Register TagPrefix="INCLUDE" TagName="BOTTOM" src="bottom.ascx" %>

<script language="C#" runat="server">
void btnLogin_Click(object sender, EventArgs e)
{
  Response.Redirect("/home_start/member_login.aspx");
}
</script>



<INCLUDE:TOP runat="server" />



<div id="content">


<center>

	<br><br>

	<b>게시판에 글을 쓰기 위해서는 로그인 해야합니다.</b>

	<br><br>
  로그인 하시려면 클릭하세요
  <br><br>
  <form runat="server">
  <ASP:Button class="btn btn-info" id="btnLogin" runat="server" text="로그인 바로가기" OnClick="btnLogin_Click" />
  </form>

</center>



</div>



<INCLUDE:BOTTOM runat="server" />
