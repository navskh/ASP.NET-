<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "Study" %>

<%@ Register TagPrefix="INCLUDE" TagName="TOP" src="top.ascx" %>
<%@ Register TagPrefix="INCLUDE" TagName="BOTTOM" src="bottom.ascx" %>

<script language="C#" runat="server">

void Page_Load(){

  if(!String.IsNullOrEmpty((string)Session["login_id"])) btnGotoLogin.Visible = false;
  else btnGotoLogin.Visible = true;

  Board BOARD_LIB = new Board();
  Database DB = new Database();

  // 요청상태 별로 글 수를 가져옴.
  float TOTAL_COUNT = BOARD_LIB.WhㄴatisCount("all");
  float READY_COUNT = BOARD_LIB.WhatisCount("접수");
  float PROGRESS_COUNT = BOARD_LIB.WhatisCount("처리중");
  float CANNOT_COUNT = BOARD_LIB.WhatisCount("불가");
  float DELAY_COUNT = BOARD_LIB.WhatisCount("지연");
  float FINISH_COUNT = BOARD_LIB.WhatisCount("완료");

  string PROGRESS_PERCENT = String.Format("{0:0.0}%",((PROGRESS_COUNT )/ TOTAL_COUNT)*  100);
  ltlProgressPercent.Text = PercentDisplay(PROGRESS_PERCENT, "secondary");
  
  string READY_PERCENT = String.Format("{0:0.0}%",((READY_COUNT) /TOTAL_COUNT) * 100);
  ltlReadyPercent.Text = PercentDisplay(READY_PERCENT, "primary");

  string CANNOT_PERCENT = String.Format("{0:0.0}%",((CANNOT_COUNT) /TOTAL_COUNT) * 100);
  ltlCannotPercent.Text = PercentDisplay(CANNOT_PERCENT, "danger");

  string DELAY_PERCENT = String.Format("{0:0.0}%",((DELAY_COUNT) /TOTAL_COUNT) * 100);
  ltlDelayPercent.Text = PercentDisplay(DELAY_PERCENT, "warning");

  string FINISH_PERCENT = String.Format("{0:0.0}%",((FINISH_COUNT) /TOTAL_COUNT) * 100);
  ltlFinishPercent.Text = PercentDisplay(FINISH_PERCENT, "success");

  string WORK_PERCENT = String.Format("{0:0.0}%",100-((READY_COUNT) /TOTAL_COUNT) * 100);
  ltlMessage.Text = "<h4 style='margin-left:30' class=txt-info> 현재 진행률은 " + WORK_PERCENT + "입니다. </h4>";
  
  if(!String.IsNullOrEmpty((string)Session["login_nick"])&&(string)Session["user_type"]=="개발자")
  {
    TOTAL_COUNT = BOARD_LIB.WhatisYourCount("all", (string)Session["login_nick"]);
    PROGRESS_COUNT = BOARD_LIB.WhatisYourCount("처리중", (string)Session["login_nick"]);
    CANNOT_COUNT = BOARD_LIB.WhatisYourCount("불가", (string)Session["login_nick"]);
    DELAY_COUNT = BOARD_LIB.WhatisYourCount("지연", (string)Session["login_nick"]);
    FINISH_COUNT = BOARD_LIB.WhatisYourCount("완료", (string)Session["login_nick"]);

    FINISH_PERCENT = String.Format("{0:0.0}%",(FINISH_COUNT /TOTAL_COUNT)*100);
    ltlFinishPercent2.Text = PercentDisplay(FINISH_PERCENT, "success");
    PROGRESS_PERCENT = String.Format("{0:0.0}%",(PROGRESS_COUNT /TOTAL_COUNT)*100);
    ltlProgressPercent2.Text = PercentDisplay(PROGRESS_PERCENT, "secondary");
    CANNOT_PERCENT = String.Format("{0:0.0}%",(CANNOT_COUNT /TOTAL_COUNT)*100);
    ltlCannotPercent2.Text = PercentDisplay(CANNOT_PERCENT, "danger");
    DELAY_PERCENT = String.Format("{0:0.0}%",(DELAY_COUNT /TOTAL_COUNT)*100);
    ltlDelayPercent2.Text = PercentDisplay(DELAY_PERCENT, "warning");
    WORK_PERCENT = String.Format("{0:0.0}%",100-((PROGRESS_COUNT) /TOTAL_COUNT) * 100);

    if(TOTAL_COUNT == 0)
    {
      ltlMessage2.Text = "<h1 style='margin-left: 30;'> 본인 요청 진행 상황 </h1> <h4 style='margin-left:30;'> 현재 진행하는 요청 내역이 없습니다. </h4>";
      progress2.Visible = false;
    }
    else
    ltlMessage2.Text = "<h1 style='margin-left: 30;'> 본인 요청 진행 상황 </h1> <h4 style='margin-left:30;'> 현재 진행률은 " + WORK_PERCENT + "입니다. </h4>";
  }
  else
  {
    progress2.Visible = false;
    ltlMessage2.Visible = false;
  }
}

string PercentDisplay(string percent, string color_type)
{
  string message = "";
  switch(color_type){
    case "secondary":
    message = "처리중 ";
    break;

    case "primary":
    message = "요청 ";
    break;

    case "danger":
    message = "불가 ";
    break;

    case "warning":
    message = "지연 ";
    break;

    case "success":
    message = "완료 ";
    break;
  }
  string valueString = String.Format("<div class='progress-bar bg-{0}' role='progressbar' style='width: {1}' aria-valuenow=30 aria-valuemin=0 aria-valuemax=100>" + " <button type=button class='btn btn-{0}' data-toggle=tooltip title='{3} {2}' style='height:100%;'></button>", color_type, percent, percent, message); 

  return valueString;
}

void btnGotoLogin_Click(object sender, EventArgs e)
{
  Response.Redirect("member_login.aspx");
}
</script>

<INCLUDE:TOP runat="server" />
<!-- ----------------------------------여기서부터 내용 ---------->
<form runat="server">
<div id="content">
  <center>
<h1 style="margin:30 0 0 30"> <b>닷넷 게시판 메인화면</b>
  <ASP:Button class="btn btn-info" id="btnGotoLogin" runat="server" text="로그인하러 가기" OnClick="btnGotoLogin_Click" />
</h1>
  </center>
</form>

<h1 style="margin-left: 30;"> 전체 요청 진행 상황 </h1>
<ASP:Literal id="ltlMessage" runat="server"/>

<div class="progress" style="width:95%; margin:30 0 0 30; height: 40" >
  <ASP:Literal id="ltlReadyPercent" runat="server" /> </div>
  <ASP:Literal id="ltlProgressPercent" runat="server" /> </div>
  <ASP:Literal id="ltlFinishPercent" runat="server" /> </div>
  <ASP:Literal id="ltlDelayPercent" runat="server" /> </div>
  <ASP:Literal id="ltlCannotPercent" runat="server" /> </div>
</div>


<br> 

<ASP:Literal id="ltlMessage2" runat="server"/>
<div class="progress" id="progress2" runat="server" style="width:95%; margin:30 0 0 30; height: 40">
  <ASP:Literal id="ltlProgressPercent2" runat="server" /> </div>
  <ASP:Literal id="ltlFinishPercent2" runat="server" /> </div>
  <ASP:Literal id="ltlDelayPercent2" runat="server" /> </div>
  <ASP:Literal id="ltlCannotPercent2" runat="server" /> </div>
</div>

<h4 align="right" style="margin-right: 90;"> 
  <span class="badge badge-primary">요청</span>
  <span class="badge badge-secondary">처리중</span>
  <span class="badge badge-success">완료</span>
  <span class="badge badge-danger">불가</span>
  <span class="badge badge-warning">지연</span>
</h4>
<h4 align="right" style="margin-right: 90;"> 
※요청 현황은 일주일 단위로 보여주는 것입니다. 
</h4>


<br>
<br>


<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script> 
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

<script> 
$(document).ready(function(){ $('[data-toggle="tooltip"]').tooltip(); }); 
</script>


<!-- ----------------------------------내용 끝 ---------->
<INCLUDE:BOTTOM runat="server" />
