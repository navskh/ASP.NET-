<form runat="server">

..
<!-- 입력 -->
<table width="600" style="border-collapse:collapse; border:1 solid slategray;">
<tr align="center">
<td width="100"><input type="text" size="8" id="name" runat="server"></td>
<td width="400"><input type="text" size="58" id="memo" runat="server"></td>
<td width="100"><input type="submit" value="메모저장" runat="server" onserverclick="Memo_Save"></td>
</tr>
<tr align="center">
<td width="100">이름</td>
<td width="400">메모</td>
<td width="400">시간</td>
</tr>
</table>
<br>

<%@ Page Language="C#" runat="server" %>
<%@ Import Namespace = "System.IO" %>
<script language="C#" runat="server">

void Page_Load()
{
}
void Memo_Save(object o, EventArgs e)
{
  string count_path = "c:\\home\\home\\memo.txt";
  string memomemo = name.Value + "_#_" + memo.Value + "_#_"+ System.DateTime.Now;
  if (File.Exists(count_path) == false) 
  {
      // 파일이 없을 때
      StreamWriter sw = File.CreateText(count_path);   
      sw.WriteLine(memomemo);   
      sw.Close();
  }
  else
  {
    // 파일이 있을 때
    string abc = File.ReadAllText(count_path);
    StreamWriter sw = File.CreateText(count_path);
    sw.WriteLine(abc+memomemo);
    sw.Close();
    abc = File.ReadAllText(count_path);
    string[] sepline = abc.Split('\n');
    foreach(var i in sepline)
    {
      string[] sep = i.Split('_','#');  
      foreach (var sub in sep)
      {
          Response.Write(sub);
          Response.Write("&nbsp");
      }
      Response.Write("<br>");
    }
  }
  
}
</script>
</form>

