

<%@ Page Language="C#" runat="server" %>
<script language="C#" runat="server">

void Page_Load()
{
  Response.Write("IsPostBack: " + IsPostBack + "<br>");
  Response.Write("Page_Load() 되었음");
    if (!IsPostBack)
  {
      // 기존값을 불러왔다고 가정
      name.Text = "김길동";
      age.Text = "25";
  }
}

void btn_Click(object o, EventArgs e)
{
  Response.Write("btn_Click() 되었음");

  // 수정된 결과 출력
  Response.Write("name: " + name.Text + "<br>");
  Response.Write("age: " + age.Text + "<br>");
}


</script>


<form runat="server">

이름 : <ASP:TextBox id="name" runat="server" />
<br>
나이 : <ASP:TextBox id="age" runat="server" />
<br>
<br>
<ASP:Button text="보내기" runat="server" OnClick="btn_Click" />

</form>
