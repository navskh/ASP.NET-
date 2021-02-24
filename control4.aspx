<%@ Page Language="C#" runat="server" %>
<script language="C#" runat="server">

void Page_Load()
{
}

void btn1_Click(object source, EventArgs e)
{
  string output = String.Format("{0}({1})님의 방문을 환영합니다.", txt1.Text, list1.SelectedValue);
  lbl1.Text = output;
}

</script>


<html>
<head>
<title>웹폼</title>
</head>

<body>

<form runat="server">
이름: <ASP:TextBox id="txt1" runat="server" />
성별:
<ASP:DropDownList id="list1" runat="server">
  <ASP:ListItem value="남">남자</ASP:ListItem>
  <ASP:ListItem value="여">여자</ASP:ListItem>
</ASP:DropDownList>

<ASP:Button id="btn1" runat="server" text="인사하기!" onclick="btn1_Click" />
</form>
<ASP:Label  id="lbl1" runat="server" />


</body>
</html>