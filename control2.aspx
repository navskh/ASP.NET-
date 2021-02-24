<%@ Page Language="C#" runat="server" %>
<script language="C#" runat="server">

  void Page_Load()
	{
		HtmlForm form = new HtmlForm();	

		HtmlInputText textbox = new HtmlInputText();
		textbox.ID = "user_name";
		textbox.Size = 20;

		HtmlInputSubmit button = new HtmlInputSubmit();
		button.Value = "인사하기";
		button.ServerClick += new EventHandler(button_click);

		HtmlGenericControl generic = new HtmlGenericControl();
		generic.ID = "output";	

		BODY_TAG.Controls.Add(form);
		BODY_TAG.Controls.Add(generic);
		form.Controls.Add(textbox);
		form.Controls.Add(button);

	}


	void button_click(object source, EventArgs e)
	{		
		HtmlGenericControl output_tag = ((HtmlGenericControl)FindControl("output"));
		HtmlInputText textbox = ((HtmlInputText)FindControl("user_name"));

		output_tag.Attributes.Remove("style");

    if (textbox.Value == "")
    {
      output_tag.Attributes.Add("style", "color:red;");
      output_tag.InnerText = "이름을 입력하세요!";
    }
    else output_tag.InnerText = "Hello! " + textbox.Value;
  }

</script>


<html id="HTML_TAG" runat="server">
<head id="HEAD_TAG" runat="server">
    <title id="TITLE_TAG" runat="server"></title>
</head>

<body id="BODY_TAG" runat="server">
</body>

</html>