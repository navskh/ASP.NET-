<%@ Page Language="C#" runat="server" %>
<%@ Import Namespace = "System.IO" %>
<script language="C#" runat="server">

void Page_Load()
{
  string count_path = "c:\\home\\count.txt";
  StreamWriter sw = File.CreateText(count_path);
  sw.Close();
}


</script>
<html>
  <head>
    <title>방문자는?</title>
  </head>
  <body>
    <center><font color="red">392</font> 번째 방문객입니다.</center>
  </body>
</html>