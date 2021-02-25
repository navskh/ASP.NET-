using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using BehindSample;

public partial class Behind : Page
{
  protected DataGrid dg1;
  protected TextBox txtName;

  protected void Button_Click(object sender, EventArgs e)
  {
    database DB = new database();

    dg1.DataSource = DB.GetDataTable(txtName.Text);
    dg1.DataBind();
  }
}