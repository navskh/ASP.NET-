<%@ Register TagPrefix="INCLUDE" TagName="TOP" src="top.ascx" %>
<%@ Register TagPrefix="INCLUDE" TagName="BOTTOM" src="bottom.ascx" %>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "Study" %>

<script language="C#" runat="server">
void Page_Load(){
  
}
void btnLogin_Click(object sender, EventArgs e){
  loginproc();
}

void loginproc()
{
    string id = txtID.Text.Trim();
    string pwd = txtPass.Text.Trim();
    string message = "";
    string query = String.Format("SELECT * FROM member WHERE user_id='{0}' AND user_password='{1}'", id, pwd);
    
    Database DB = new Database();  
    DataTable dtMember = DB.ExecuteQueryDataTable(query);

    // 자료 없음
    if (dtMember.Rows.Count == 0)
    {
      // 명시적으로 인스턴스 소멸(생략가능)
      dtMember.Dispose();        

      message = "아이디 혹은 비밀번호가 올바르지 않습니다.";
    }
    
    // 자료 있음
    else
    {
      // 세션변수 2개 할당
      Session["login_id"] = id;
      Session["login_nick"] = dtMember.Rows[0]["nickname"];
      string user_type = (string)dtMember.Rows[0]["user_type"];
      
      if(user_type == "PD"){
        Session["user_type"] = "개발자";
      }
      else if(user_type == "Manger"){
        Session["user_type"] = "운영자";
      }
      else{
        Session["user_type"] = "미등록";
      }


      message = String.Format("{0}({1}) 회원님. 로그인이 성공하였습니다~", Session["login_id"], Session["login_nick"]); 

      // 명시적으로 인스턴스 소멸(생략가능)
      dtMember.Dispose();  

      Response.Redirect("/home_start/index.aspx");
    }
    
    //Response.Redirect(Request.Url.PathAndQuery);
    // 최종 메시지
    lblLoginResult.ForeColor = System.Drawing.Color.Red;
    lblLoginResult.Text = message;
}
</script>

<INCLUDE:TOP runat="server" />
<!-- ----------------------------------여기서부터 내용 ---------->

<div id="content">
<center>
<br>
<br>
<h1>로그인</h1>

<div id="login_start" runat="server">
  <form runat="server">
    <table width="300">
      <tr>
        <td>  <ASP:TextBox class="form-control" id="txtID" PlaceHolder="ID를 입력하세요" runat="server" /> </td>
      </tr>
      <tr>
        <td> <ASP:TextBox class="form-control" id="txtPass" PlaceHolder="password를 입력하세요" textmode="password" runat="server" /> </td>
      </tr>
      </table>
  <br>
  <ASP:Button class="btn btn-info" id="btnLogin" runat="server" text="로그인" OnClick="btnLogin_Click" />

  <br>
  <br>
  <ASP:Label id="lblLoginResult" runat="server" Text="" />
  </form>
</div>

<!-- ----------------------------------내용 끝 ---------->
<INCLUDE:BOTTOM runat="server" />
