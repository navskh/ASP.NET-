
<%@ Import Namespace = "System.Drawing" %>
<%@ Page Language="C#" runat="server" %>
<script language="C#" runat="server">

void Page_Load()
{

}

</script>


<html>
<head>
<title>웹폼 - Calendar 컨트롤</title>
</head>

<body>


<form runat="server">
<ASP:Calendar id="cal1" runat="server"
Width="500"
Height="500"
ShowGridLines="true"
>

<DayHeaderStyle BackColor="yellow"></DayHeaderStyle>
</ASP:Calendar>
</form>


</body>
</html>