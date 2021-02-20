<%@ Page Language="C#" runat="server" %>

<script language="C#" runat="server">

void Page_Load()
{
  string name = Request["name"]; 
  string title = Request["title"]; 
  string content = Request["content"]; 
  string password = Request["password"]; 

  Response.Write("이름 : " + name + "<hr>");
  Response.Write("제목 : " + title + "<hr>");
  Response.Write("내용 : " + content + "<hr>");
  Response.Write("비번 : " + password + "<hr>");

}

</script>