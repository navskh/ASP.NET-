<script language="C#" runat="server">
  void Page_Load()
  {
    string NOW_FILE = Request.ServerVariables["script_name"];

    bool IsLogin = false;
    if(Session["login_id"] != null) 
      IsLogin = true;

    switch(NOW_FILE)
    {
      // 글쓰기 페이지 일 때
      case "/board_write.aspx" :
        if(!IsLogin)
          Response.Redirect("./board_loginmsg.aspx");
        break;

      // 글 읽기 페이지 일 때
      case "/board_view.aspx" :
        break;

      case "/board_list.aspx" :
        break;
    }
  }

</script>


