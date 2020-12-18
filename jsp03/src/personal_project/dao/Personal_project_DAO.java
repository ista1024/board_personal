package personal_project.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;

import personal_project.dto.Personal_project_BoardDTO;
import personal_project.dto.Personal_project_CommentDTO;
import personal_project.dto.Personal_project_MemberDTO;
import sqlmap.MybatisManager;

public class Personal_project_DAO {
	
	public List<Personal_project_MemberDTO> memberList(){
		List<Personal_project_MemberDTO> memberList = null;
		try(SqlSession session = MybatisManager.getInstance().openSession()) {
			memberList = session.selectList("Personal_project.memberList");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return memberList;
	} // memberList()

	public List<Personal_project_BoardDTO> accountBookList(Personal_project_BoardDTO dto) {
		SqlSession session = MybatisManager.getInstance().openSession();
		List<Personal_project_BoardDTO> list = null;
		if (dto == null) {
			list = null;
		} else {
			list = session.selectList("Personal_project.accountBookList", dto);
		}
		session.close();
		return list;
	} // accountBookList()

	public Personal_project_MemberDTO loginCheck(Personal_project_MemberDTO dto) {
		Personal_project_MemberDTO result = null;
		try(SqlSession session = MybatisManager.getInstance().openSession()) {
			result = session.selectOne("Personal_project.loginCheck", dto);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	} // loginCheck()

	public int joinMember(Personal_project_MemberDTO dto) {
		int result = -1;
		try(SqlSession session = MybatisManager.getInstance().openSession()) {
			result = session.insert("Personal_project.joinMember", dto);
			session.commit();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	} // joinMember()

	public int deleteAllMember() {
		int result = -1;
		try (SqlSession session = MybatisManager.getInstance().openSession()) {
			session.delete("Personal_project.deleteAllMember");
			session.commit();
			result = 1;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	} // deleteAllMember()

	public int boardListCount() {
		int result = 0;
		try(SqlSession session = MybatisManager.getInstance().openSession()) {
			result = session.selectOne("Personal_project.boardListCount");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	} // boardListCount()

	public List<Personal_project_BoardDTO> boardList(int start, int end) {
		List<Personal_project_BoardDTO> list = null;
		try (SqlSession session = MybatisManager.getInstance().openSession()) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("start", start);
			map.put("end", end);
			list = session.selectList("Personal_project.boardList", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	} // boardList()

	public Personal_project_BoardDTO viewBoardContent(int num) {
		Personal_project_BoardDTO dto = null;
		try (SqlSession session = MybatisManager.getInstance().openSession()) {
			dto = session.selectOne("Personal_project.viewBoardContent", num);
			// 줄바꿈 처리
			String content = dto.getContent();
			content = content.replace("\n", "<br>");
			dto.setContent(content);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return dto;
	} // viewBoardContent()

	public List<Personal_project_CommentDTO> commentList(int num) {
		List<Personal_project_CommentDTO> list = null;
		try (SqlSession session = MybatisManager.getInstance().openSession()) {
			list = session.selectList("Personal_project.commentList", num);
		} catch (Exception e) {
			e.printStackTrace();
		} 
		return list;
	} // commentList()
	
	public Personal_project_CommentDTO commentView(int comment_num) {
		Personal_project_CommentDTO dto = null;
		try (SqlSession session = MybatisManager.getInstance().openSession()) {
			dto = session.selectOne("Personal_project.commentView", comment_num);
			// 줄바꿈 처리
			String content = dto.getContent();
			content = content.replace("\n", "<br>");
			dto.setContent(content);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return dto;
	} // viewBoardContent()

	public void insertBoard(Personal_project_BoardDTO dto) {
		try (SqlSession session = MybatisManager.getInstance().openSession()) {
			session.insert("Personal_project.insertBoard", dto);
			session.commit();
		} catch (Exception e) {
			e.printStackTrace();
		} 
	} // insertBoard()

	// 첨부파일 이름 찾기
	public String getFileName(int num) {
		String result = "";
		try (SqlSession session = MybatisManager.getInstance().openSession()) {
			result = session.selectOne("Personal_project.getFileName", num);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	} // getFileName()

	public void plusDown(int num) {
		try (SqlSession session = MybatisManager.getInstance().openSession()) {
			session.update("Personal_project.plusDown", num);
			session.commit();
		} catch (Exception e) {
			e.printStackTrace();
		} // try
	} // plusDown()

	// 게시판 초기화
	public void deleteAllBoard() {
		try (SqlSession session = MybatisManager.getInstance().openSession()) {
			session.delete("Personal_project.deleteAllComment");
			session.commit();
			session.delete("Personal_project.deleteAllBoard");
			session.commit();
		} catch (Exception e) {
			e.printStackTrace();
		} // try
	} // plusDown()

	// 조회수 증가 처리
	public void plusReadCount(int num, HttpSession count_session) {
		try (SqlSession session = MybatisManager.getInstance().openSession()) {
			long read_time = 0;
			if (count_session.getAttribute("read_time_" + num) != null) {
				read_time = (long)count_session.getAttribute("read_time_" + num);
			}
			long current_time = System.currentTimeMillis(); // 현재시각 밀리초
			if (current_time - read_time > 10 * 1000) { // 현재시간 = 읽은시간 > 10초
				// 하루에 한 번이면 24 * 60 * 60 * 1000
				session.update("Personal_project.plusReadCount", num);
				session.commit();
				// 최근 열람 시각 업데이트
				count_session.setAttribute("read_time_" + num, current_time);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	} // plusReadCount()

	public String passwdCheck(int num, String passwd) {
		String result = null;
		try (SqlSession session = MybatisManager.getInstance().openSession()) {
			Map<String, Object> map = new HashMap<>();
			map.put("num", num);
			map.put("passwd", passwd);
			result = session.selectOne("Personal_project.boardPass_check", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	} // passwdCheck()

	public void updateBoard(Personal_project_BoardDTO dto) {
		try (SqlSession session = MybatisManager.getInstance().openSession()) {
			session.update("Personal_project.updateBoard", dto);
			session.commit();
		} catch (Exception e) {
			e.printStackTrace();
		}
	} // updateBoard()

	public void deleteBoard(int num) {
		try (SqlSession session = MybatisManager.getInstance().openSession()) {
			session.update("Personal_project.deleteBoard", num);
			session.commit();
		} catch (Exception e) {
			e.printStackTrace();
		}
	} // deleteBoard()
	
	public void deleteBoardByManager(int num) {
		try (SqlSession session = MybatisManager.getInstance().openSession()) {
			session.update("Personal_project.deleteBoardByManager", num);
			session.commit();
		} catch (Exception e) {
			e.printStackTrace();
		}
	} // deleteBoardByManager()

	public void updateCommentStep(int board_num, int comment_ref, int comment_re_step) {
		try (SqlSession session = MybatisManager.getInstance().openSession()) {
			Personal_project_CommentDTO dto = new Personal_project_CommentDTO();
			dto.setBoard_num(board_num);
			dto.setComment_ref(comment_ref);
			dto.setComment_re_step(comment_re_step);
			session.update("Personal_project.updateCommentStep", dto);
			session.commit();
		} catch (Exception e) {
			e.printStackTrace();
		}
	} // updateStep()
	
	public void addComment(Personal_project_CommentDTO dto) {
		try (SqlSession session = MybatisManager.getInstance().openSession()) {
			session.insert("Personal_project.addComment", dto);
			session.commit();
		} catch (Exception e) {
			e.printStackTrace();
		}
	} // addComment()

	// 답글의 순서를 조정
	public void updateStep(int ref, int re_step) {
		try (SqlSession session = MybatisManager.getInstance().openSession()) {
			Personal_project_BoardDTO dto = new Personal_project_BoardDTO();
			dto.setRef(ref);
			dto.setRe_step(re_step);
			session.update("Personal_project.updateStep", dto);
			session.commit();
		} catch (Exception e) {
			e.printStackTrace();
		}
	} // updateStep()

	// 답글 쓰기
	public void insertBoardReply(Personal_project_BoardDTO dto) {
		try (SqlSession session = MybatisManager.getInstance().openSession()) {
			session.insert("Personal_project.insertBoardReply", dto);
			session.commit();
		} catch (Exception e) {
			e.printStackTrace();
		}
	} // insertBoardReply

	public void addCommentReply(Personal_project_CommentDTO dto) {
		try (SqlSession session = MybatisManager.getInstance().openSession()) {
			session.insert("Personal_project.addCommentReply", dto);
			session.commit();
		} catch (Exception e) {
			e.printStackTrace();
		}
	} // addCommentReply()

	public int checkRank(String userid) {
		int checkRank = 0;
		try (SqlSession session = MybatisManager.getInstance().openSession()) {
			checkRank = session.selectOne("Personal_project.checkRank", userid);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return checkRank;
	} // checkRank()

	public void updateMember(Personal_project_MemberDTO dto) {
		try (SqlSession session = MybatisManager.getInstance().openSession()) {
			session.update("Personal_project.updateMember", dto);
			session.commit();
		} catch (Exception e) {
			e.printStackTrace();
		}
	} // updateMember()

	public List<Personal_project_BoardDTO> searchBoard(String search_option, String keyword) {
		List<Personal_project_BoardDTO> boardList = null;
		try (SqlSession session = MybatisManager.getInstance().openSession()) {
			Map<String, String> map = new HashMap<String, String>();
			map.put("search_option", search_option);
			map.put("keyword", "%" + keyword + "%");
			boardList = session.selectList("Personal_project.searchBoard", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return boardList;
	} // searchBoard()

	public String joinCheck(String userid) {
		String result = "";
		try (SqlSession session = MybatisManager.getInstance().openSession()) {
			result = session.selectOne("Personal_project.joinCheck", userid);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	

}
