using System;
using System.Web.UI;
using System.Web.UI.HtmlControls;
public partial class Include : UserControl
{
  protected void Page_Load(object sender, EventArgs e)
    {
    if (Request["menu"] != null)
      ( (HtmlTableCell)FindControl("td" + Request["menu"]) ).Attributes.Add("bgcolor", "yellow");
    }
}
