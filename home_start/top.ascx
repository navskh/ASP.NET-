<script language="C#" runat="server" Debug="true">

void Page_Load()
{
  Session["login_id"] = "test";
  Session["login_nick"] = "테스터";

  if (Session["login_id"] != null)
  {
    login.Visible = false;
    member_join.Visible = false;
    logout.Visible = true;

    lblNickName.Text = (string)(Session["login_nick"]+"님 로그인 되었습니다.");
  }
  lblNickName.ForeColor = System.Drawing.Color.White;
}
</script>


<head>
<title>닷넷 게시판</title>

<<<<<<< HEAD
<!--<link rel="stylesheet" type="text/css" href="/home_start/default.css">-->
=======
<link rel="stylesheet" type="text/css" href="/home_start/default.css">
</head>
<body>

<div id="top">
  <center>
	<a href="index.aspx">
	  <img src="./img/top.png" width="700" height="200">
  </a>
  </center>
</div>

<div id="main_menu">
>>>>>>> 98bf81b08597eb5ac8af7f075610ae85cdbed5da

<link rel="stylesheet" type="text/css" href="/home_start/bootstrap.css">

<<<<<<< HEAD
=======
	<a href="index.aspx">메인화면</a>
	|
	<a href="member_join.aspx">회원가입</a>
  <!--회원가입 메뉴로 이동!-->
	| 
	<a href="board_list.aspx?c=test">자유게시판</a>
	|
	<a href="board_list.aspx?c=photo">포토게시판</a>
	|
	<a href="board_list.aspx?c=guestbook">방명록</a>
  |
  <a href="board_list.aspx?c=qna">질답게시판</a>
	<hr color="slategray">
>>>>>>> 98bf81b08597eb5ac8af7f075610ae85cdbed5da

</head>
<body>

<div id="top">
  <center>
  <a href="index.aspx">
    <img src="./img/jinhak.png" width="1000" height="280">
  </a>
  </center>
</div>

<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarColor01" aria-controls="navbarColor01" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>

  <ul class="navbar-nav mr-auto">
    <li class="nav-item"><a class="nav-link" href="index.aspx">메인화면</a></li>

  <span id="member_join" runat="server">  
    <li class="nav-item"><a class="nav-link" href="member_join.aspx">회원가입</a> </li>
  </span>

  <span id="login" runat="server">
    <li class="nav-item"><a class="nav-link" href="member_login.aspx">로그인</a> </li>
  </span> 
    <li class="nav-item"><a class="nav-link" href="board_list.aspx?c=pims">1. PIMS요청사항</a> </li>
    <li class="nav-item"><a class="nav-link" href="board_list.aspx?c=study">2. 교육내용정리</a> </li>
    <li class="nav-item"><a class="nav-link" href="board_list.aspx?c=photo">(포토게시판)</a></li>
    <li class="nav-item"><a class="nav-link" href="board_list.aspx?c=guestbook">(방명록)</a></li>
    <li class="nav-item"><a class="nav-link" href="board_list.aspx?c=qna">(질답게시판)</a> </li>
  </ul>

  <span id="logout" runat="server" visible="false">
  <a class="nav-link" href="logout.aspx">로그아웃</a> 
  </span>
  <b><ASP:Label id="lblNickName" runat="server" Text=""/> </b>
</nav>

</body>