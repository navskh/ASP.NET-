<%@ Page Language="C#" Inherits="Behind" %>
<%@ Register TagPrefix="INCLUDE" TagName="TOP" src="top.ascx" %>
<%@ Register TagPrefix="INCLUDE" TagName="BOTTOM" src="bottom.ascx" %>

<INCLUDE:TOP runat="server" />
<form runat="server">

  <ASP:TextBox id="txtName" runat="server" />
  <ASP:Button runat="server" text="쿼리문 실행" OnClick="Button_Click" />

  <br>
  <ASP:DataGrid id="dg1" runat="server" />


</form>

<INCLUDE:BOTTOM runat="server" />

