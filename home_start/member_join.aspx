<%@ Register TagPrefix="INCLUDE" TagName="TOP" src="top.ascx" %>
<%@ Register TagPrefix="INCLUDE" TagName="BOTTOM" src="bottom.ascx" %>
<%@ Import Namespace = "Study" %>


<script language="C#" runat="server">

  void Page_Load()
  {
    string Password1 = txtPass.Text;
    txtPass.Attributes.Add("value", Password1);
    string Password2 = txtPassCheck.Text;
    txtPassCheck.Attributes.Add("value", Password2);

    btnGotoLogin.Visible = false;
  }
  void btnCheck_Click(object sender, EventArgs e)
  {
    string id = txtID.Text;

    // 일단 사용할 수 있는 ID라고 가정
    bool bCheck = true;
    // 출력할 오류메시지 문자열
    string check_message = "";
    // 1. 빈ID : 문자열의 앞,뒤 공백을제거한 byte가 0이면
    if (id.Trim().Length == 0)
    {
      bCheck = false;
      check_message = "아이디를 입력해주세요.";
    }
    // 2. 영문자,숫자만 가능
    else if ( !CheckStep2(id) )
    {
      bCheck = false;
      check_message = "공백없이 영문/숫자만 가능합니다.";
    }
    // 3. 4~12자리만
    else if ( id.Length < 4 || id.Length > 12  )
    {
      bCheck = false;
      check_message = "4~12자로 정해주세요.";
    }

    // 모두 통과하였으면
  if (bCheck)
  {
    // 최종 DB체크
    Database DB = new Database();

    // member 테이블에 user_id가 "id"변수인 자료가 총 몇개?
    string query = "SELECT COUNT(*) FROM member WHERE user_id='" + id + "'";

    // 쿼리의 결과는 1개 뿐이고, int 형이다.
    int result_count = (int)DB.ExecuteQueryResult(query);

    // 자료가 존재함 (존재한다면 1개밖에 있을 수 밖에 없다) - 사용불가
    if (result_count == 1)
    {
      lblCheckResult.ForeColor = System.Drawing.Color.Red;
      check_message = "이미 존재하는 ID입니다.";
      hdnCheckID.Value = "";
    }
    // 자료가 없음 - 사용가능
    else
    {
      lblCheckResult.ForeColor = System.Drawing.Color.Blue;
      check_message = "사용할 수 있는 ID입니다.";
      hdnCheckID.Value = "1";
    }
  }
  // 통과하지 못헀다면
  else
  {
    lblCheckResult.ForeColor = System.Drawing.Color.Red;
    hdnCheckID.Value = "";
  }
  
  // 메시지를 뿌려준다.
  lblCheckResult.Text = check_message;
}

bool CheckStep2(string text)
{
  int k = 0;

  for(int i=0;i<text.Length;i++)
  {  
    char c = text[i];
    //영어체크
    if( ( 0x61 <= c && c <= 0x7A ) || ( 0x41 <= c && c <= 0x5A ) ) k++;
    //숫자체크
    else if( 0x30 <= c && c <= 0x39 ) k++;
  }
  if (k != text.Length) return false;
  else return true;  
}

void btnJoin_Click(object sender, EventArgs e)
{
  string passwd = txtPass.Text.Trim();
  string nickname = txtNick.Text.Trim();
  string Telnum = txtTelnum.Text.Trim();
  string user_type = DropDownList1.SelectedItem.Value;

  // 역시 통과했다고 미리 가정.
  bool bChecked = true;
  string check_message = "";

  // 메서드를 이용한 값비교. '==' 연산자와 동일한 기능이다.
  // ID중복체크 확인값이 없다면
  if (!hdnCheckID.Value.Equals("1"))
  {
    bChecked = false;
    check_message = "아이디 중복확인을 해주세요.";
  }
  // 비밀번호 공백체크
  else if (passwd.Length == 0)
  {
    bChecked = false;
    check_message = "비밀번호를 입력하세요.";
  }
  // 닉네임 공백체크
  else if (nickname.Length == 0)
  {
    bChecked = false;
    check_message = "이름을 입력하세요.";
  }
  else if (!hdnCheckPass.Value.Equals("1"))
  {
    bChecked = false;
    check_message = "비밀번호 확인이 안되었습니다.";
  }
  else if (Telnum.Length == 0)
  {
    bChecked = false;
    check_message = "전화번호를 입력해주세요.";
  }

  // 모두 통과됨
  if (bChecked)
  {
    // DB에 INSERT로 저장
    Database DB = new Database();
    string query = "INSERT INTO member(user_id, user_password, nickname, user_type, telnum) VALUES('"
    + txtID.Text + "', '" + passwd  + "', '" + nickname + "', '" + user_type + "', '" + txtTelnum.Text + "')";
    DB.ExecuteQuery(query);

    lblJoinResult.ForeColor = System.Drawing.Color.Blue;
    lblJoinResult.Text = "회원가입이 완료되었습니다.";

    //dg1.DataSource = DB.ExecuteQueryDataTable("Select * from //member");
    //dg1.DataBind();

    // 로그인 완료 얼럿창
    string alert_str = "<script language=JavaScript> alert('회원가입이 완료되었습니다.');" +"</"+ "script>";
    ClientScript.RegisterStartupScript(typeof(Page), "alert", alert_str);

    btnGotoLogin.Visible = true;
  }
  // 오류발생
  else
  {
    lblJoinResult.ForeColor = System.Drawing.Color.Red;
    lblJoinResult.Text = check_message;
  }

}

void btnPassCheck_Click(object sender, EventArgs e)
{
  if(txtPassCheck.Text==txtPass.Text){
    lblPassCheckResult.ForeColor = System.Drawing.Color.Green;
    lblPassCheckResult.Text = "비밀번호가 확인되었습니다.";
    hdnCheckPass.Value = "1";
  }
  else
  {
    lblPassCheckResult.ForeColor = System.Drawing.Color.Red;
    lblPassCheckResult.Text = "비밀번호가 일치하지않습니다.";
    hdnCheckPass.Value = "";
  }
}

void btnGotoLogin_Click(object sender, EventArgs e)
{
  Response.Redirect("member_login.aspx");
}
</script>



<INCLUDE:TOP runat="server" />
<!-- ----------------------------------여기서부터 내용 ---------->



<div id="content">
<center>
<h1>어서오세요! 회원가입을 진행해주세요</h1>
<hr>
<form runat="server">
<ASP:HiddenField id="hdnCheckID" runat="server" />
<ASP:HiddenField id="hdnCheckPass" runat="server" />

<table class = table-member>
  <tr>
    <td width="150"> 회원아이디 </td>
    <td width="260" >  <ASP:TextBox class="form-control" id="txtID" runat="server" /> </td>
    <td> <ASP:Button class="btn btn-danger" id="btnCheck" runat="server" text="중복체크!" OnClick="btnCheck_Click"/>
    <ASP:Label id="lblCheckResult" runat="server"/> </td>
  </tr>
  <tr>
    <td>  비밀번호  </td>
    <td> <ASP:TextBox class="form-control" id="txtPass" textmode="password" runat="server" /> </td>
    <td width=400> </td>
  </tr>
  <tr>
    <td>  비밀번호 확인 </td>
    <td> <ASP:TextBox class="form-control" id="txtPassCheck" textmode="password" runat="server" /> </td>
    <td> <ASP:Button class="btn btn-success" id="btnPassCheck" runat="server" text="비밀번호 체크" OnClick="btnPassCheck_Click"/>
      <ASP:Label id="lblPassCheckResult" runat="server"/> </td>
  </tr>
  <tr>
    <td>  이름 </td>
    <td> <ASP:TextBox class="form-control" id="txtNick" runat="server" /> </td>
  </tr>
  <tr>
    <td>  직책  </td>
    <td> <ASP:DropDownList class="form-control" id="DropDownList1" runat="server"> 
      <asp:ListItem Value="Manger">운영자</asp:ListItem>
      <asp:ListItem Value="PD">개발자</asp:ListItem>
      <asp:ListItem Value="teacher">학교관계자</asp:ListItem>
    </asp:DropDownList>
    </td>                
  </tr>
  <tr>
    <td>  전화번호  </td>
    <td> <ASP:TextBox class="form-control" id="txtTelnum" runat="server" /> </td>
  </tr>

</table>  


  <br>
  <ASP:Button class="btn btn-info" id="btnJoin" runat="server" text="회원가입 완료" OnClick="btnJoin_Click" />
  
  <br>
  <ASP:Label id="lblJoinResult" runat="server" text = "" />

  <br>

  <ASP:Button class="btn btn-info" id="btnGotoLogin" runat="server" text="로그인하러 가기" OnClick="btnGotoLogin_Click" />

</center>
</form>

</div>

<!-- ----------------------------------내용 끝 ---------->
<INCLUDE:BOTTOM runat="server" />

