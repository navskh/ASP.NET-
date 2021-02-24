<%@ Page Language="C#" runat="server" %>

<script language="C#" runat="server">

	void Page_Load()
	{
    //1. Panel 컨트롤 생성 
    // Panel 컨트롤의 결과 : <div> 태그
		Panel panel = new Panel();
		
    // 2. Panel 컨트롤에 Label 컨트롤을 생성하여 추가.
    // Label 컨트롤의 결과 : <span> 태그
		Label lbl = new Label();
		panel.Controls.Add(lbl); // <div> <span> </span> </div>
		
    // 3. Label 텍스트 속성에 "안녕하세요" string 값을 넣어줌.
		lbl.Text = "안녕하세요"; //<div> <span> 안녕하세요 </span> </div>

    // 4. Calendar 컨트롤을생성하여 Panel 컨트롤에 추가.
		Calendar cal = new Calendar(); 

    // 달력은 <form></form> 사이에 와야 하므로 form 컨트롤 만들어 줌.
		HtmlForm form = new HtmlForm();
		form.Controls.Add(cal);

    // form 컨트롤에 달력 넣어서 panel로 넣어줌.
		//panel.Controls.Add(form);
    // <div> <form> <cal> </form> </div>

    // 5. Drop Down Lst 컨트롤 생성
		DropDownList list = new DropDownList();

    // 아이템 추가
		list.Items.Add(new ListItem("1", "1"));
		list.Items.Add(new ListItem("2", "2"));
		list.Items.Add(new ListItem("3", "3"));

    // Drop Down List도 <form> </form> 안에 와야 하므로 form태그에 추가
		form.Controls.Add(list);
    // 근데 왜 panel 컨트롤에는 추가를 안해주지?? 그리고 근데 왜 잘 되지?
    // 내 생각에는 panel 컨트롤은 그냥 div 태그이기 때문에 디폴트 설정으로 아래 표시 되는 듯하고
    // 아마 추가해주면.. 별 차이 없음. 왜 그렇지?
    panel.Controls.Add(form);
    
		Page.Controls.Add(panel);
	}

</script>


