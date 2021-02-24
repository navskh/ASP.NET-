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

  // 파일저장부분
  HttpPostedFile files = Request.Files["uploadfile"];

  string target_path = Server.MapPath("\\");   // "c:\\home"
  string file_name = files.FileName;
  files.SaveAs(target_path + @"\" + file_name); // c:\home\파일명.

  Response.Write("업로드파일 : " + file_name + "(사이즈 : " + files.ContentLength + " bytes) <hr>");
  
}
</script>