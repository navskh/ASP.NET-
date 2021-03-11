<%@ Register TagPrefix="INCLUDE" TagName="TOP" src="top.ascx" %>
<%@ Register TagPrefix="INCLUDE" TagName="BOTTOM" src="bottom.ascx" %>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "Study" %>

<script language="C#" runat="server">
  void Page_Load()
  {
    string id = Request.Form["user_id"];
    string pwd = Request.Form["user_pw"];
    string message = "";
    string query = String.Format("SELECT * FROM member WHERE user_id='{0}' AND user_password='{1}'", id, pwd);
    
    Database DB = new Database();  
    DataTable dtMember = DB.ExecuteQueryDataTable(query);

    // 자료 없음
    if (dtMember.Rows.Count == 0)
    message = "회원을 찾을 수 없습니다.";
    // 자료 있음
    else
    {
    // 세션변수 2개 할당
    Session["login_id"] = id;
    Session["login_nick"] = dtMember.Rows[0]["nickname"];

    message = String.Format("{0}({1}) 회원님. 로그인이 성공하였습니다~", Session["login_id"], Session["login_nick"]); 

    }

    // 명시적으로 인스턴스 소멸(생략가능)
    dtMember.Dispose();
    
    // 최종 메시지
    lblMessage.Text = message;
  }
</script>

<INCLUDE:TOP runat="server" />

<!--------------------------- 여기서부터 내용 ------>
<div id="content">
  <center>
  [로그인처리결과]
  <br>
  <br>
  <ASP:Label id="lblMessage" runat="server" forecolor="blue" />
</center>
</div>
<!-- 내용끝 ---------------------------------------->

<INCLUDE:BOTTOM runat="server" />
