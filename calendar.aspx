
<%@ Import Namespace = "System.Drawing" %>
<%@ Page Language="C#" runat="server" %>
<script language="C#" runat="server">

void Page_Load()
{
  cal1.Width = 500;
  cal1.Height = 500;

  cal1.ShowGridLines = true;

  cal1.DayHeaderStyle.BackColor = System.Drawing.Color.Yellow;
}

</script>


<html>
<head>
<title>웹폼 - Calendar 컨트롤</title>
</head>

<body>


<form runat="server">
<ASP:Calendar id="cal1" runat="server" />
</form>


</body>
</html>