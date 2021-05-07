
<ASP.NET 게시판 리뷰 준비>
* 기능별 설명
  이 게시판은 좀 더 업무요청 게시판의 특성을 보여주기 위해서 제작하였다.
  메인화면 - 현제 요청 진행상황 보여짐
  회원가입 
  로그인 - 로그인 시 헤더에 누구누구 로그인 했는지 보여줌. / 로그아웃
  PIMS 요청사항
    - 리스트, 글 조회 (리스트의 색상은 현재 요청상태에 따라 달라짐. 접수(흰), 지연(황), 처리중(회), 완료(녹), 불가(적))
    - 운영자는 글 작성 (폰트 변경 가능), 조회가 가능, 자신이 작성한 글이면 수정, 삭제 가능 
    - 개발자는 글 조회, 요청 상태 변경이 가능
    - 댓글 숫자가 제목 옆에 숫자로 표시됨.
    - 요청 시 메일 보내짐.

0. 개발환경

  - asp.net 기반으로 만들고, c# 사용
  - 부트스트랩
    https://bootswatch.com/
    Flatly 테마 사용

1. index.aspx
    일단 Page_Load() 되면
    
    db단에 연결함.
    bin에 dll을 넣어서 사용하는데 기본 코드는 .cs 파일을 보면된다.

    - Database.cs 파일
    기본적으로 DB에 접속하고 Query 수행할 수 있게 해주는 코드.
    DBOpen() : DB에 접속
    DBClose() : DB에 접속 끊음.
    ExcuteQuery() : ExcutenonQuery 호출. INSERT, UPDATE, delete 사용 시 .
    ExcuteQueryResult() : ExecuteScalar 호출, 결과가 하나의 데이터일 경우 사용
    ExecuteQeuryDataTable() : db의 결과 dataset을 가져오는 경우 사용한다.

    - 진행 상황 Progress bar 
      ⓐ 일단 통계를 보여줘야하므로 요청상태별로 그 숫자를 알아야한다.
        board.cs > WhatisCount() 메서드
        condition : 요청상태를 받아서 db에서 해당 요청상태로 검색하게 만들어줌.

      ⓑ 숫자를 알았으면 요청 상태별로 퍼센티지를 알아야한다.
        PercentDisplay(percent, color_type)
        두번째 인자가 color_type인 이유는 해당 name을 class에 부여해서 부트스트랩에 지정된 색깔 입혀줄 것임
        대충 메세지 바꿔주고
        결국 div 태그로 바꿔줌. color_type, percent를 사용해서 원하는 색상과 퍼센트만큼 넓이를 설정하여 띄워줌.

      ⓒ progress bar는 두가지 종류가 있음
        개발자로 로그인하면 자신의 처리한 요청들의 퍼센티지를 보여주려 만들었다.
        (클릭하면 그 글들만 보여지게 만들려 했는데 일단 보류하였음.)

2. member_join.aspx (회원가입) 
    1) UI 
      아이디, 중복체크
      비밀번호
      비밀번호 확인
      이름
      직책
      전화번호
      회원가입 완료
      로그인하러 가기
      
    2) 히든필드
      hdnCheckID  : 아이디 중복확인
      hdnChcekPass : 비밀번호 확인
      변수로 사용할 애들을 지정한 것임

    3) 아이디 입력 시 
      txtIDChanged() 호출 : hdnCheckID 를 빈 문자열로 만듬
      중복확인 한 후 아이디를 다시 바꾸게 되면 아이디 중복확인을 가능하게끔 만들기 위함임.

      btnCheck_Click : 중복체크 버튼 클릭하면 호출됨.
      check_message를 만들어 조건에 맞게 중복체크 시 옆에 띄워주게 만듬.
      모든 조건 통과하면
      select 문으로 ExecuteQueryResult 로 같은 아이디가 발견되면
      이미 존재하는 id 라는 메세지 찍어줌.
      없으면 사용할 수 있는 id라고 찍어주고
      hdnCheckID 값을 1로 만들어줌

    4) 비밀번호 입력 시 
      txtPassCheckChanged() 호출 : hdnChcekPass 를 빈문자열로 만들어 비밀번호 확인 후 비밀번호 바꿀 시 다시 확인하게 만듬

    5) 비밀번호 확인 버튼 클릭 시
      btnPassCheck_Click()  호출 : 
        비밀번호 텍스트와 비밀번호 확인 텍스트 가 같으면 비밀번호 확인 후 hdnChcekPass 를 1로 만듬
        다르다면 일치 안한다는 문구 출력

    6) 회원가입하기 버튼 클릭 시
      btnJoin_Click()
      - 비밀번호
      - 이름
      - 전화번호
      - 직책
      정보 받아서 넣어줌

      그다음에 모두 이상 없는지 체크하고 
      모두 통과 되면
      db에 insert 문으로 user_info 테이블에 삽입
      회원가입 완료 메세지 출력
      alert 창 띄워주고
      끝에 로그인하러 곧바로 갈 수 있도록 버튼 출력

3. 로그인 (member_login)
    1) UI
    그냥 id, 비밀번호 입력할 수 있게 만들어 줌

    2) 동작
    아이디, 패스워드 입력하고 로그인 버튼 클릭하면
    loginproc()
    select 문으로 해당 아이디와 패스워드로 검색하여 있으면
    아이디, 닉네임, user_type 정보 받아줌.

    session 변수가 있어서 여기에 저장하면 
    board_top에서 출력해줄 수 있다.

    3) board_top.aspx
    로그인 되어 있는 상태라면
    로그인/회원가입 버튼은 안보이게 만듬.
    로그아웃 버튼을 보이게 만들어주고
    Session 값에 집어넣은 login_nick 정보를 받아와 이름을 출력해줌

    로그아웃 버튼을 누르면 logout.aspx로 이동하게 됨

4. 로그아웃 (logout.aspx)
    로그아웃 버튼 누르면, Sesison.abandon() 이 되어 Session에 있는 정보들을 지우게 됨.

5. 글 목록 - board_list.aspx (+ 댓글 보임)
    1) UI
    일단 baord_list.aspx 는 placeholder로 게시판의 영역을 나눠줬는데
    이는 카테고리별로 어떤 게시판을 표시해줄 건지를 나누기 위해서 이렇게 만들었다. (예제에서 이렇게 되어있었기 때문에 사용한 것이지 딱히 의미는 없다.)
    전체적으로는 테이블로 표현한다. bootstrap hover 속성을 설정하여 표 위에 커서가 올라가면 깜빡이게 만들었다.

    표 내용은 Repeater 를 사용하여 출력해준다.

    2) Repeater 의 동작
    page_load() 부분에 가보면
    rptList를 dtList에서 가져오는데..
    위로 올라가서 dtlist를 찾아보면
    dtlist 의 자료형 : (DataTable 형태)

    Board_LIB.List_PIMS를 불러온다.
    Board.cs > List_PIMS 의 동작
    현재 PAGE 값을 받아서 리스트의 시작 ID, 끝 ID를 받아온다.
    SELECT 문으로 리스트에 출력할 게시글 목록을 가져온다.

    출력되는 형태는 
    제목/ 개발자/ 요청상태/ 우선순위/ 작성자/ 작성날짜 의 방식으로 출력해준다.
    여기서 표의 시작 tr 부분을 label 태그로 설정하여 만들어준다.
    <ASP:Label id="lblTR_Open" runat="server" /> 
    리피터의 itembind시점에 호출되는 rptList_Bound() 에서보면 
    lblcondition 의 Text를 가져와서 그에 맞게 tr 태그의 class를 설정해주어 해당 줄의 색상을 변경해주는 식으로 코딩하였다.

    3) 검색을 클릭하면
    c, stype, svalue 를 가지고 검색할 수 있도록 board_list에 해당 속성값을 url과 함께 넘긴다.
    page_load() 시점에서
    해당 데이터들 받아온 후 
    List_PIMS 불러올 때 where문을 사용하여 검색하여주는 것이다.

    4) 페이징 동작을 보면
    총 글 수 가져온 후 (TOTAL_COUNT)
    PAGE_SIZE로 나누면 총 페이지의 갯수를 구할 수 있다.
    (나머지가 있다면 1을 더해준다.)

    PAGE_BLOCK은 페이지를 10페이지 단위로 끊어서 보여주겠다는 것이다.
    NOW_BLOCK은 현재 페이지의 블록이다.

    ⓐ PageGen1은 한칸씩 이동하는 페이지 링크를 만드는 것이다. (◁이전 | 다음▷)
      간단하다. 지금 페이지가 1이면 이전을 그냥 텍스트로 만드는 것이고 지금페이지가 마지막 페이지면 다음을 텍스트로 만든다.
      그게 아니면 만일 이전/다음 버튼 클릭 시 href를 사용하여 한 칸씩 이동하도록 설정하여준다.

    ⓑ PageGen2 는 열칸씩 이동하는 기능이다.
      블록이 첫번째 블록이면 << 화살표 disable 시킴

      for문을 돌려서 
      페이지를 표시해주는데 현재 페이지는 진하게 표시

    ⓒ 113line 부턴 블록 이동하는 버튼에 대한 코드이다.
      만약 총 BLOCK 갯수가 1이면 안보이게 만들 것
      만약 BLOCK 갯수는 1이상이나 BLOCK이 1이면 좌측 버튼 disable
      만약 BLOCK 갯수가 1이상인데 마지막 BLOCK 이면 우측 버튼 disable
      다 아니면 둘 다 OPEN

    5) 댓글 보여주기 위해 CommentCount
      Board.cs > CommentAmount를 호출
      board_comment 테이블에는 board_id와 댓글 정보가 다 입력된 테이블이다.
      여기에 board_id를 통해 board_comment의 갯수를 알 수 있음.(select 문)
      []안에 넣어서 출력해줌

    6) 글쓰기 버튼 클릭시 
    btnWriteboard_Click() 호출
    login 을 한 상태에서 글 작성할 수 있음
    운영자만 글 작성할 수 있음

    운영자면 board_write.aspx?c=pims 로 넘어감

6. 글 작성 (board_wirte)  (+ 에디터 + 메일 송신 기능)
    1) UI
    여러 정보들 받는데 
    에디터는 FreeTextBox를 썼음 (FTB)
    FreeTextBox에서는 원하는 메뉴를 속성에 넣어주면 됨

    2) 글쓰기 버튼 클릭 시 btnWrite_Click 호출
    여러 데이터들 받아와서 일단 조건 검사함.
    (제목, 서비스 아이디, 서비스 명 빈칸으로 올 수 없음)

    모든 조건이 만족한다면
    먼저 upload_file 받아옴.
    업로드 파일은 현재 파일시스템에서 "upload" 파일에 파일들을 저장함.
    upload.Saveas를 사용하여 첨부파일 저장함.

    수정 모드면 Modify를 가져오고, 글쓰기면 Write를 가져옴
    : Moddify는 update, Write는 Insert

    그 후 MailSend()
    메일은 smtp 로 만들어서 보냄
    (gmail, outlook 메일은 정크로 가고 국내 메일은 제대로 감 근데 이것도 몇번 이상 보내면 안된다 함)

    3) 만약 수정에서 넘어왔다면..
    Read_PIMS 에 Board_ID를 넣어서 반환 받은 값들을
    현재 표에다가 입력시켜 상태를 복원해준다.

7. 글 조회 (pims_board_view) (+ 수정/삭제 + 요청상태 변경 기능)
    1) UI
      작성 표와 거의 동일하게 보여준다.
      특이한게 있다면 요청상태가 개발자에게는 DROPDOWNLIST로 보이고  운영자에게는 그냥 TEXT로 보인다는 것.

      내용, 댓글 내용에 가면
      <ASP:Label id="lblContent" runat="server" style="word-wrap:break-word; white-space: pre-line; table-layout: fixed;" />
      이런 속성들이 있는데 이는 줄바꿈을 허락하기 위한 속성들이다.

      로그인한 아이디가 작성한 아이디와 같다면 수정/삭제 버튼을 활성화 시켜주었다

    2) Page_Load
      ⓐ 댓글창
        로그인이 안되어 있으면 댓글 쓰기 영역을 없앤다.
        로그인 되어 있으면 해당 아이디로 댓글 쓸 수 있도록 만들어준다.

      ⓑ 데이터 바인딩 

      ⓒ 요청상태
        개발자면 Dropdownlist를 보여줌
        운영자면 text로 보여줌

        요청상태는 맨처음 글 작성 되었을 때는 "접수"
        그러면 "처리중","접수" 만 뜨게끔 만들고 그 외 아이템은 enable=false로 만듬.
        처리중으로 만들면 그 후에 다른 값들 enable을 true로 만들어 줌.

        맨처음 view 창 load 되면 
        접수면 그냥 띄우고

        접수 상태가 아니였으면 그 상태 그대로 띄워주게끔 
        일단 처리중, 완료, 지연, 불가 열어주고
        이전 상태 그대로 선택되게끔 만듬

    3) 요청상태 변경 시 (condition_change)
      ⓐ 처음 처리중으로 바꿨을 때
        얼럿창 띄워주고
        개발자 부분에 현재 로그인 되어있는 개발자 이름을 넣어주고
        db update 시켜줌. "처리중으로"

      ⓑ 그 외 다른 상태로 바꿨을 때
        db update 시켜준 후 그 상태대로 유지되게끔 설정해줌

    4) 댓글 입력 (btnCommentWrite_Click)
      댓글 등록되어 있지 않으면 댓글 등록해야한다 메세지 출력
      
      댓글이 존재하면 CommentWrite() 호출
      insert 문으로 board_comment에 입력

      CommentList() 호출
    
    5) CommentList()
      board.cs > CommentList 호출하여  select 문으로 해당 board_id의 board_comment 정보를 가져온다.
      dataBind() 시켜 리피터에 찍어준다.

    6) 댓글 출력 시 rptComment_Bound 를 호출한다.
      운영자의 경우 황색
      개발자의 경우 녹색으로 뜨게끔 만듬

    7) 삭제 시 btnDelete_Click
      Remove_PIMS 를 불러와 해당 BoardID 의 열을 delete 시켜주게끔 만들었다.
