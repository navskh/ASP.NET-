<script language="C#" runat="server">

void Page_Load()
{
  Session["login_id"] = "test";
  Session["login_nick"] = "테스터";

  if (Session["login_id"] != null)
  {
    login_start.Visible = false;
    login_done.Visible = true;
    lblNickName.Text = (string)Session["login_nick"];
  }
}
</script>


<head>
<title>닷넷 게시판</title>
</head>
<body>

<div id="top">
	
	<img src="./img/top.png" width="700" height="200">

</div>

<div id="main_menu">


	<a href="index.aspx">메인화면</a>
	|
	<a href="member_join.aspx">회원가입</a>
  <!--회원가입 메뉴로 이동!-->
	| 
	<a href="board_list.aspx?c=test">자유게시판</a>
	|
	<a href="board_list.aspx">포토게시판</a>
	|
	<a href="">방명록</a>

  <!--
  |
  <a href="Study.aspx">스터디 테스트</a>
  |
  <a href="board_write.aspx">테스트2</a>
  -->
	<hr color="slategray">

</div>


<div id="login_start" runat="server" style="background-color:#eeddff">
  <form action="login_proc.aspx" method="post" style="display:inline; margin:0">
    <font color="blue">[로그인]</font>
    ID : <input type="text" id="user_id" name="user_id" size="10">
    PW : <input type="password" id="user_pw" name="user_pw" size="10">
    <input type="submit" value="로그인">
  </form>
</div>

<div id="login_done" runat="server" style="background-color:#eeddff" visible="false">
  <form action="logout.aspx" style="display:inline; margin:0">
  어서오세요! <ASP:Label id="lblNickName" runat="server" /> 님. 반갑습니다.
  <input type="submit" value="로그아웃">
  </form>
</div>


</body>