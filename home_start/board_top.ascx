<script language="C#" runat="server">
  void Page_Load()
  {
    string NOW_FILE = Request.ServerVariables["script_name"];
    string CATEGORY = Request["c"];

    // 카테고리 검사
    // 'C' 값이 비어있어도 잘못된 접근
    if(String.IsNullOrEmpty(CATEGORY))
    {
      Response.Redirect("board_categorymsg.aspx");
    }
    // 값이 있다면 체크
    else
    {
      // 다음값들만 허용되므로 아니라면 오류
      if(!(CATEGORY.Equals("pims") ||
          CATEGORY.Equals("study")))
          {
            Response.Redirect("./board_categorymsg.aspx");
          }
    }
    // 카테고리 검사 끝 

    
    bool IsLogin = false;
    if(Session["login_id"] != null) 
      IsLogin = true;

    switch(NOW_FILE)
    {
      // 글쓰기 페이지 일 때
      case "/home_start/board_write.aspx" :
        if(!IsLogin)
          Response.Redirect("./board_loginmsg.aspx");
        break;

      // 글 읽기 페이지 일 때
      case "/home_start/board_view.aspx" :
        break;

      case "/home_start/board_list.aspx" :
        break;
    }
  }

</script>


