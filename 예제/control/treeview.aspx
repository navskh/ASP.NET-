<%@ Page Language="C#" runat="server"%>

<script language="C#" runat="server">

void Page_Load()
{
    Controls[1].Visible = false;        
    ((LiteralControl)Controls[2]).Text = "End Of File";
}

</script>


<html>
<head>
<title>웹폼 - TreeView 컨트롤</title>
</head>

<body>


<form runat="server" id="frm">

<ASP:TreeView id="tree1" ExpandDepth="0" runat="server">
<Nodes>
<asp:TreeNode Text="하위메뉴열기" SelectAction="Expand"> 
<asp:TreeNode Text="메뉴1" />
<asp:TreeNode Text="메뉴2" />  
      <asp:TreeNode Text="메뉴3" SelectAction="Expand">
          <asp:TreeNode Text="메뉴 3-1" />  
          <asp:TreeNode Text="메뉴 3-2" />
      </asp:TreeNode>  
</asp:TreeNode>
</Nodes>
</ASP:TreeView>

</form>

</body>
</html>
