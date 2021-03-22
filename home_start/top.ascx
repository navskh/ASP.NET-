<script language="C#" runat="server" Debug="true">

void Page_Load()
{
  // 테스트를 위한 아이디와 닉네임
  //Session["login_id"] = "navskh";
  //Session["login_nick"] = "성영훈";
  //Session["user_type"] = "개발자";

  // 로그인 완료된 후 로그인 탭 지우고 로그인 문구와 함께 로그아웃 탭 보이게 할 것.
  if (Session["login_id"] != null)
  {
    login.Visible = false;
    member_join.Visible = false;
    logout.Visible = true;

    lblNickName.Text = (string)(Session["login_nick"]+ "님 (" + Session["user_type"] + "님)로그인 되었습니다.");
  }
  lblNickName.ForeColor = System.Drawing.Color.White;
}
</script>


<head>
<title>PIMS 업무요청 게시판</title>

<!--<link rel="stylesheet" type="text/css" href="/home_start/default.css">-->

<!--BOOTSRAP 링크, https://bootswatch.com/flatly/ 참조-->
<link rel="stylesheet" type="text/css" href="/home_start/bootstrap.css">


</head>
<body>

<!--게시판 상단 이미지-->
<div id="top">
  <center>
  <a href="index.aspx">
    <img src="img\jinhak.png" width="1000" height="280">
  </a>
  </center>
</div>

<!--게시판 상단 네비게이터 바-->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarColor01" aria-controls="navbarColor01" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>

  <ul class="navbar-nav mr-auto">
    <li class="nav-item"><a class="nav-link" href="index.aspx">메인화면</a></li>

  <li class="nav-item" id="member_join" runat="server">
    <a class="nav-link" href="member_join.aspx">회원가입</a>
  </li>
  <li class="nav-item" id="login" runat="server">
    <a class="nav-link" href="member_login.aspx">로그인</a>
  </li>
    <li class="nav-item"><a class="nav-link" href="board_list.aspx?c=pims">1. PIMS요청사항</a> </li>
    <li class="nav-item"><a class="nav-link" href="board_list.aspx?c=study">2. 교육내용정리</a> </li>
  </ul>

  <span id="logout" runat="server" visible="false">
  <a class="nav-link" href="logout.aspx">로그아웃</a> 
  </span>
  <!--로그인 문구 출력 -->
  <b><ASP:Label id="lblNickName" runat="server" Text=""/> </b>
</nav>

</body>