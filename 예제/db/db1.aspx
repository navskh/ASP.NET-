<%@ Page Language="C#" runat="server" %>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "System.Data.SqlClient" %>
<script language="C#" runat="server">

  void Page_Load()
  { 
    /*string str_conn = "server=NAVSKH;user id=sa; password=jos0109!;database=aspnet";
    SqlConnection conn = new SqlConnection(str_conn);

    Response.Write ("before: " + conn.State + "<hr>");

    conn.Open();
    Response.Write ("Open(): " + conn.State + "<hr>");  

    conn.Close();
    Response.Write ("close(): " + conn.State + "<hr>");  
    */
    
    string str_conn = "server=NAVSKH;user id=sa;password=jos0109!;database=aspnet;";
    SqlConnection conn = new SqlConnection(str_conn);
    conn.Open();
    
    // DB연동작업 시작
    
    string QUERY ="SELECT user_name FROM member_table";
    SqlCommand cmd = new SqlCommand(QUERY, conn);
    object result = cmd.ExecuteScalar();
    Response.Write(result);
    // DB연동작업 끝
    conn.Close();
  }

</script>