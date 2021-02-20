<%@ Page Language="C#" runat="server" Debug="true" %> <!--C#으로 작성한다는 선언문-->
<%@ Import Namespace = "System.IO" %>
<script language="C#" runat="server"> 
// 소스코드의 시작
void Page_Load()  // 자동 실행 메서드
  {
    string count_path = "c:\\home\\count3.txt";
    int new_count = 1;
    if (File.Exists(count_path) == false) 
      {
          // 파일이 없을 때
          StreamWriter sw = File.CreateText(count_path);   
          sw.WriteLine("1");   
          sw.Close();
      }
      else
      {
         // 파일이 있을 때
        StreamReader sr = File.OpenText(count_path);
        string now_count = sr.ReadLine();
        sr.Close();

        new_count = Int32.Parse(now_count)+1;
        StreamWriter sw = File.CreateText(count_path);
        sw.WriteLine(new_count);
        sw.Close();
      }

      Response.Write(new_count);
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