<%@ Page Language="C#" runat="server" Debug="true" %>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "System.Data.SqlClient" %>

<script language="C#" runat="server">

 void Page_Load()
 {
  string str_conn = "server=NAVSKH;user id=sa;password=jos0109!;database=aspnet;";
  SqlConnection conn = new SqlConnection(str_conn);
  conn.Open();

  
  // DB연동작업 시작
  
    string QUERY ="SELECT * FROM member_table";
    SqlCommand cmd = new SqlCommand(QUERY, conn);
    SqlDataReader data = cmd.ExecuteReader();
    
    while(data.Read()){
      Response.Write(String.Format("사용자 : {0} (이름:{1}, 비밀번호 : {2})<br>등록일:{3}<hr>",data[0],data["user_name"],data[1],data[3]));
    }


  // DB연동작업 끝
  conn.Close();
 }


</script>