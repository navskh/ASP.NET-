
<%@ Register TagPrefix="INCLUDE" TagName="TOP" src="top.ascx" %>
<%@ Register TagPrefix="INCLUDE" TagName="BOTTOM" src="bottom.ascx" %>
<%@ Import Namespace = "Study" %>

<INCLUDE:TOP runat="server" />
<script language="C#" runat="server">
  void Button_Click(object sender, EventArgs e)
  { 
    Database db = new Database();
    // select --> ExecuteQueryDataTable
    // insert --> ExecuteQuery
    // update --> ExecuteQuery
    // delete --> ExecuteQuery
    char Fircha  = txtName.Text[0];
    if(Fircha == 's'){
      dg1.DataSource = db.ExecuteQueryDataTable(txtName.Text);  
      dg1.DataBind();
    }
    else if(Fircha == 'i' || Fircha == 'u' || Fircha == 'd') {
      db.ExecuteQuery(txtName.Text);
      lblResult.Text = "명령이 정상적으로 실행되었습니다.";
      dg1.DataSource = db.ExecuteQueryDataTable("Select * from member");
      dg1.DataBind();
    }
    else lblResult.Text = "명령이 이상합니다.";
  
    //dg1.DataSource = db.ExecuteQueryDataTable(txtName.Text);
    //dg1.DataBind();
  }
  void btnJoin_Click(object sender, EventArgs e)
  {

  }
</script>

<form runat="server">

  <ASP:TextBox id="txtName" runat="server" />
  <ASP:Button runat="server" text="쿼리문 실행" OnClick="Button_Click" />


  <br>
  <asp:Label ID="lblResult" runat="server" Text="결과 출력" />

  <br>
  <ASP:DataGrid id="dg1" runat="server" />


</form>

<INCLUDE:BOTTOM runat="server" />