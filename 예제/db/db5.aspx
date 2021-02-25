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

    // DB연동작업 끝
    conn.Close();

    rpt1.DataSource = ds.Tables[0];
    rpt1.DataBind();

  }

</script>


<ASP:Repeater id="rpt1" runat="server">

<ItemTemplate>
  <%# Eval("user_name") %>
  <br>
  가입일 : <b><%# ((DateTime)Eval("user_regdate")).ToString("yyyy-MM-dd") %></b>
  <hr>
</ItemTemplate>

</ASP:Repeater>