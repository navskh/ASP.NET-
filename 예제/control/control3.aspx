<%@ Page Language="C#" runat="server" %>

<script language="C#" runat="server">

	void table_make(object src, EventArgs e)
	{
		int cel = Int32.Parse(cell.Value);
		int r = Int32.Parse(row.Value);
		
		// <table>..</table>
		HtmlTable TABLE = new HtmlTable();

		// <table border="0"></table>
		TABLE.Border = 0;
		
		// <tr>루프
		for (int i=0; i<r; i++)
		{
			// <tr>..</tr>
			HtmlTableRow TR = new HtmlTableRow();

			// <tr bgcolor="#{0}{1}{2}"> --> "#010101"
			TR.BgColor = String.Format(
								"#{0}{1}{2}", 
								(i%99).ToString("00"), 
								(i%99).ToString("00"), 
								(i%99).ToString("00") 
						);

			// <tr>내의 <td>루프
			for (int j=0; j<cel; j++ )
			{
				// <td>..</td>
				HtmlTableCell TD = new HtmlTableCell();
				TD.Width = "30";         // <td width="30">
				TD.Height = "30";        // <td width="30" height="30">
				TD.Align = "Center";     // <td width="30" height="30 align="center">

				// <td width="30" height="30 align="center" style="font-size:8pt; color:white;">
				TD.Attributes.Add("style", "font-size:8pt; color:white;");

				// <td ...>{0}x{1}</td>
				TD.InnerText = String.Format("{0}x{1}", i+1, j+1);

				// <tr>에 <td>추가
				TR.Cells.Add(TD);
			}


			// <table>에 <tr>추가
			TABLE.Rows.Add(TR);

		}

		// <body>에 <table> 추가
		BODY_TAG.Controls.Add(TABLE);

	}


</script>


<html>
<head>
<title>테이블 동적으로 만들기</title>
</head>

<body id="BODY_TAG" runat="server">

<form runat="server">
	행(Cell): <input type="text" size="3" id="cell" runat="server"><br>
	열(Row): <input type="text" size="3" id="row" runat="server"><br>
	<input type="submit" runat="server" onserverclick="table_make" value="생성하기">
</form>



<hr>
[테이블 결과]
<hr>



</body>


</html>