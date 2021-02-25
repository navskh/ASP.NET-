using System;
using System.Data;

//글쓰기, 읽기, 리스트 등의 기능을 구현하기 위해 데이터베이스와 연동
using Study;

namespace Study
{
  public class Board
  {
    Database DB;
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

  }

}