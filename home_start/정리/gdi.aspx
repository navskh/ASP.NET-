<%@ Page Language="C#" runat="server" Debug="true"%>
<%@ Import Namespace = "System.Drawing" %>
<%@ Import Namespace = "System.Drawing.Imaging" %>

<script language="C#" runat="server">
  void Page_Load()
  {
    // DB로부터 자료를 가져온다. (Study를 Import 하지 않았으므로)
    Study.Database DB = new Study.Database();

    // 포토게시판의 최근 1개 자료를 가져온다.
    System.Data.DataTable dt = DB.ExecuteQueryDataTable(
      "SELECT TOP 1 * FROM board WHERE category='photo' ORDER BY board_id DESC"
    );

    // 비트맵 클래스로 첨부파일 이미지를 불러옴
    Bitmap img = new Bitmap(Server.MapPath("/home_start/upload/" + dt.Rows[0]["file_attach"]));

    // Graphics 객체를 시작한다.
    Graphics g = Graphics.FromImage(img);

    // 이미지 처리
    Response.Write("size: " + img.Size);
    g.DrawString(
      String.Format("제목: {0} ",dt.Rows[0]["title"]),
      new Font("돋움", 32.0f),
      new SolidBrush(Color.Red),
      new Point(50,50)
    );

    g.DrawString(
      String.Format("올린이 : {0}", dt.Rows[0]["user_name"]),
      new Font("돋움", 16.0f),
      new SolidBrush(Color.Red),
      new Point(50,100)
    );

    img.Save(Server.MapPath("upload/new_"+dt.Rows[0]["file_attach"]), ImageFormat.Jpeg);

    // 크기 변경
    Bitmap img_newsize = new Bitmap(80, 60);
    g = Graphics.FromImage(img_newsize);
    g.DrawImage(img, 0, 0, 80, 60);

    img_newsize.Save(Server.MapPath("upload/small_" + dt.Rows[0]["file_attach"]), ImageFormat.Jpeg);

    // aspx 파일을 이미지 파일 형식으로 변경
    Response.ContentType = "image/jpeg";

    // Bimap.Save(Stream, ImageFormat) 메서드 이용
    img_newsize.Save(Response.OutputStream, ImageFormat.Jpeg);

    // System.Drawing 에서 사용한 것들은 꼭 메모리를 반환해야 한다.
    img_newsize.Dispose();
    img.Dispose();
    g.Dispose();

    // dt는 자동으로 제거되지만 명시적으로 반환
    dt.Dispose();
  }
</script>