using System;
using System.Data;
using System.Data.SqlClient;

namespace BehindSample
{
    public class database{
      public DataTable GetDataTable(string Query)
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

        // DataSet.DataTable 1개 리턴
        return ds.Tables[0];
      }
    }
}