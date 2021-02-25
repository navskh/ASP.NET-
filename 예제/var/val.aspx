<%@ Page Language="C#" runat="server" %>
<script language="C#" runat="server">

void Page_Load()
{

  if (Application["count"] == null)
  Application["count"] = 0;

  if (Session["count"] == null)
  Session["count"] = 0;


  Application["count"] = (int)Application["count"]+1;
  Session["count"] = (int)Session["count"]+1;

  Response.Write("app: " +  Application["count"] + "<br>");
  Response.Write("session: " +  Session["count"]);
  
}


</script>
