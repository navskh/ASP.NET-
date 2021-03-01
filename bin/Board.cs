using System;
using System.Data;
using System.Web;

//글쓰기, 읽기, 리스트 등의 기능을 구현하기 위해 데이터베이스와 연동
using Study;

namespace Study
{
  public class Board
  {
    Database DB;

    public int PAGE_SIZE = 10;

    public Board()
    {
      DB = new Database();
    }

    // 게시판 글쓰기
    public void Write( string category, string user_id, string user_name, string title, string content, string upload_file)
    {
      string query = String.Format("INSERT INTO board (category, user_id, user_name, title, content, file_attach) VALUES('{0}', '{1}', '{2}', '{3}', '{4}', '{5}')", 
              category, user_id, user_name, title, content, upload_file);
      
      DB.ExecuteQuery(query);
    }

    // 게시판 목록
    public DataTable List(string category)
    {
      return DB.ExecuteQueryDataTable("SELECT * FROM board WHERE category='" + category + "' ORDER BY board_id desc");
    }

    public DataTable Read(string category, int number)
    {
      string query = String.Format("SELECT * FROM board WHERE category='{0}' AND board_id={1}", category, number);
      return DB.ExecuteQueryDataTable(query);         
    }

    public void CommentWrite(int board_id, string user_id, string user_name, string content)
    {
      string query = String.Format("INSERT INTO board_comment(board_id, user_id, user_name, content) VALUES({0}, '{1}', '{2}', '{3}')",
            board_id, user_id, user_name, content);

      DB.ExecuteQuery(query);
    }

    public DataTable CommentList(int board_id)
    {
      string query = "SELECT * FROM board_comment WHERE board_id=" + board_id + " ORDER BY comment_id";
      return DB.ExecuteQueryDataTable(query);   
    }

    public void ReadUp(string category, int number)
    {
      string query = String.Format("UPDATE board SET readnum=readnum+1 WHERE category='{0}' AND board_id={1}",category,number);
      DB.ExecuteQuery(query);
    }
    
    public void Recommend(string category, int number)
    {
      string query = String.Format("UPDATE board SET recommend=recommend+1 WHERE category='{0}' AND board_id={1}",category,number);
      DB.ExecuteQuery(query);
    }

    public void Modify(int number, string title, string content, string upload_file)
    {
      string query = String.Format("UPDATE board SET title='{0}', content='{1}', file_attach='{2}' WHERE board_id={3}", 
      title, content, upload_file, number);
      DB.ExecuteQuery(query);
    }

    public void Remove(string category, int number)
    {
      // 1. 댓글 삭제
      string query = String.Format("DELETE FROM board_comment WHERE board_id={0}", number);
      DB.ExecuteQuery(query);

      // 2. 글 삭제
      query = String.Format("DELETE FROM board WHERE category='{0}' AND board_id={1}", category, number);
      DB.ExecuteQuery(query);
    }

    public DataTable List(string category, string search_target, string search_word)
    {
      return DB.ExecuteQueryDataTable(
        "SELECT * FROM board WHERE category= '" + category + "' AND " + search_target + " LiKE '%" + search_word + "%' ORDER BY board_id DESC" 
      );
    }

    public DataTable List(string category, int now_page, string search_target, string search_word)
    {
      // now_page = 3;
      int start_id, end_id;

      start_id = (now_page-1) * PAGE_SIZE;
      end_id = (now_page * PAGE_SIZE) + 1;

      System.Text.StringBuilder query = new System.Text.StringBuilder();
      query.Append("SELECT * FROM");
      query.Append(" ( ");
      query.Append("SELECT ROW_NUMBER() OVER(ORDER BY board_id DESC) AS row_num, * FROM board tmp");
      query.Append(" WHERE category = '" + category + "' ");
      if(!String.IsNullOrEmpty(search_target) && !String.IsNullOrEmpty(search_word))
        query.Append(" AND " + search_target + " LIKE '%" + search_word + "%' ");
      query.Append(" ) ");
      query.Append(" AS BOARD_NUMBERED ");
      query.Append(String.Format(" WHERE row_num>{0} AND row_num<{1}",start_id, end_id));

      return DB.ExecuteQueryDataTable(query.ToString());
      
    }

    public int ListCount(string category, string search_target, string search_word)
    {
      string query = "SELECT COUNT(*) FROM board WHERE category='" + category + "' ";

      // 검색어가 있을 때
      if(!String.IsNullOrEmpty(search_target) && !String.IsNullOrEmpty(search_word))
        query += " AND " + search_target + " LIKE '%" + search_word + "%' ";

      return (int)DB.ExecuteQueryResult(query);
    }

    // 이전/ 다음 페이지 생성
    // 인수     1: 현재 페이지 번호
    //          2: 전체 페이지 수   
    //          3: 주소에 풀어 넘길 (페이지 값을 사용함) GET 변수 명
    //          4: 기타 붙여서 넘길 값
    public string PageGen1(int now_page, int total_page, string page_val_str, string args)
    {
      // 문자열 결합으로 이어나감.
      string page_str = "";

      // 이전 페이지
      if(!now_page.Equals(1))
      {
        // 1페이지가 아니면 무조건 이동 가능
        page_str += String.Format("<a href='{0}?{1}={2}&{3}'>이전페이지</a>",
          HttpContext.Current.Request.ServerVariables["SCRIPT_NAME"],
          page_val_str,
          now_page-1,
          args);
      }
      else
      {
          // 이동불가 : 링크 없음
          page_str += "이전페이지";
      }
      // 구분자는 무조건 넣어주고
      page_str += "|";

      // 다음페이지
      if(!now_page.Equals(total_page))
      {
        // 끝 페이지가 아니면 무조건 이동가능
        page_str += String.Format("<a href='{0}?{1}={2}&{3}'>다음페이지 ▶</a>",
          HttpContext.Current.Request.ServerVariables["SCRIPT_NAME"],
          page_val_str,
          now_page+1,
          args);
      }
      else
      {
          page_str += "다음페이지";
      }

      return page_str;
    }
    public string PageGen2(int page, int totalpage, string strFileName, string strLinkString, string strLinkName, int blockcount)
    {

    string tmp = "";
    string LINK_STR = strFileName + "?" + strLinkString + "&" + strLinkName + "=#PG#";

    // 총 페이지 수로 전체 블록갯수를 구함
    int TOTAL_BLOCK = totalpage / blockcount;
    if (totalpage % blockcount != 0)
    TOTAL_BLOCK++;
    // 현재의 페이지 번호로 지금 위치한 블록을 구함
    int NOW_BLOCK = page / blockcount;
    if (page % blockcount != 0)
    NOW_BLOCK++;

    

   // 첫 페이지 이동링크
    if (page != 1)
    tmp += String.Format("<a href='{0}'>[1]</a> .. ", LINK_STR.Replace("#PG#", "1"));

    // 첫 블럭은 [이전n]이 없음 링크도 없음
    if (NOW_BLOCK == 1)
    tmp += String.Format("[이전 {0}개] .. ", blockcount);
    // 두번째 블럭은 [이전n]에 링크
    // 공식: 현재 블럭에서 앞으로 두칸 앞 블럭수에서 블럭단위를 곱해주고 +1 을 해주면 이전블럭의 첫 페이지가 구해짐
    else
    tmp += String.Format("<a href='{0}'>[이전 {1}개]</a> .. ",
      LINK_STR.Replace("#PG#", ((NOW_BLOCK-2)*blockcount+1).ToString()  ),
      blockcount);

    for (int i=1; i <= blockcount; i++)
    {
      int START_NUMBER = (NOW_BLOCK-1)*blockcount;
      // 숫자가 현재페이지와 같으면 그냥 링크없이 빨간색 진하게 표시
      if (START_NUMBER + i == page)
      {
        tmp += String.Format(" <font color='red'><b>{0}</b></font> ", page);
      }
      // 다르면 링크가능
      else
      {
        tmp += String.Format(" <a href='{0}'>{1}</a> ",
            LINK_STR.Replace("#PG#", (START_NUMBER+i).ToString()),
            ((NOW_BLOCK-1)*blockcount + i ));
      }
      // 숫자가 계속 돌다가 전체페이지에 다다르면 현재의 for()를 빠져나옴
      if (START_NUMBER + i == totalpage)
      break;
    }


    // 다음 블럭은 현재의 블럭과 총 블럭이 같지 않을 때 표시
    if (NOW_BLOCK == TOTAL_BLOCK)
      tmp += String.Format(" .. [다음 {0}개] ", blockcount);
    else
      tmp += String.Format(" .. <a href='{0}'>[다음 {1}개]</a> ",
        LINK_STR.Replace("#PG#", ((NOW_BLOCK*blockcount)+1).ToString()  ),
        blockcount);
    // 마지막 페이지 이동링크
    if (page != 1)
      tmp += String.Format(" .. <a href='{0}'>[{1}]</a>",
            LINK_STR.Replace("#PG#", totalpage.ToString()),
            totalpage);

    // 만든 페이징 리턴
    return tmp;
    }


  }

}