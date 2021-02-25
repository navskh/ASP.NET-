<html>
<form runat="server">

<input type="text" id="userid" runat="server">
<input type="password" id="pwd" runat="server">
<input type="submit" value="로그인!" runat="server" onserverclick="Login_Proc">


<%@ Page Language="C#" runat="server" %>
<script language="C#" runat="server">

void Page_Load()
{
}
void Login_Proc(object o, EventArgs e)
{
  Response.Write("아이디: " + userid.Value + "<br>");
  Response.Write("비밀번호: " + pwd.Value + "<hr>");
}
</script>
</form>
</html>
