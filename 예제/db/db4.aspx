<%@ Page Language="C#" runat="server" %>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "System.Data.SqlClient" %>

<script language="C#" runat="server">

void Page_Load()
{
  string str_conn = "server=NAVSKH;user id=sa;password=jos0109!;database=aspnet;";
  SqlConnection conn = new SqlConnection(str_conn);
  conn.Open();

  
  // DB연동작업 시작
  string QUERY = "SELECT * FROM member_table";
  SqlDataAdapter da = new SqlDataAdapter(QUERY, conn);
  DataSet ds = new DataSet();
  da.Fill(ds);
    //ds 라는 배열에 DataAdapter를 그대로 갖다 붙인 것.

  Response.Write("1. DataTable -- " + ds.Tables[0] + "<br>");
  Response.Write("2. DataTable.Rows.Count -- " + ds.Tables[0].Rows.Count + "<br>");
  Response.Write("3. DataTable.Rows -- " + ds.Tables[0].Rows + "<br>");
  Response.Write("4. DataTable.Rows[0] -- " + ds.Tables[0].Rows[0] + "<br>");
  Response.Write("5. DataTable.Columns.Count -- " + ds.Tables[0].Columns.Count + "<br>");
  Response.Write("6. DataTable.Columns -- " + ds.Tables[0].Columns + "<br>");
  Response.Write("7. DataTable.Columns[0] -- " + ds.Tables[0].Columns[0] + "<br>");

  
  DataTable dt = ds.Tables[0];  
  for (int i=0; i<dt.Rows.Count; i++ )
  {
    Response.Write(String.Format("사용자 : {0} (이름:{1}, 비밀번호:{2})<br>등록일:{3}<hr>",
    dt.Rows[i][0], dt.Rows[i]["user_name"], dt.Rows[i][1], dt.Rows[i][3] ));
  }

  // DB연동작업 끝
  conn.Close();

  dg1.DataSource = ds.Tables[0];
  dg1.DataBind();
}

</script>

<form runat="server">
<ASP:DataGrid id="dg1" runat="server" />
</form>