<%@ Page Language="C#" runat="server" %>

<script language="C#" runat="server">

void Page_Load()
{

  foreach(string vals in Request.ServerVariables)
  {
  Response.Write( "[키이름] <font color=red>" + vals + "</font> ==> [키값] <b>" + Request.ServerVariables[vals] + "</b><hr>" );
  }

}

</script>