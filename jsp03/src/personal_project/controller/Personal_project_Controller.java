package personal_project.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Enumeration;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import common.Constants;
import common.Pager;
import personal_project.dao.Personal_project_DAO;
import personal_project.dto.Personal_project_BoardDTO;
import personal_project.dto.Personal_project_CommentDTO;
import personal_project.dto.Personal_project_MemberDTO;


@WebServlet("/personal_project_servlet/*")
public class Personal_project_Controller extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String uri = request.getRequestURI();
		Personal_project_DAO dao = new Personal_project_DAO();
		String contextPath = request.getContextPath();
		if (uri.indexOf("onload.do") != -1) {
			String url = "/personal_project/index.jsp";
			response.sendRedirect(contextPath + url);
		} // onload.do
		
		else if (uri.indexOf("loginMember.do") != -1) {
			HttpSession session = request.getSession();
			session.invalidate();
			String result = "";
			String userid = request.getParameter("userid");
			String passwd = request.getParameter("passwd");
			String ip = request.getRemoteAddr();
			if (userid == null || userid.trim().equals("")) {
				result = "입력된 아이디가 없습니다.";
			} else if (passwd == null || passwd.trim().equals("")) {
				result = "입력된 비밀번호가 없습니다.";
			} else if (ip == null || ip.trim().equals("")) {
				result = "올바르지 않은 접근방법입니다.";
			} else {
				Personal_project_MemberDTO dto = new Personal_project_MemberDTO();
				dto.setUserid(userid);
				dto.setPasswd(passwd);
				dto = dao.loginCheck(dto);
				if (dto == null) {
					result = "아이디 또는 비밀번호가 일치하지 않습니다.";
				} else {
					session = request.getSession();
					session.setAttribute("userid", userid);
					session.setAttribute("passwd", passwd);
					session.setAttribute("name", dto.getName());
					session.setAttribute("member_rank", dto.getMember_rank());
					session.setAttribute("join_date", dto.getJoin_date());
					result = dto.getName() + "님 환영합니다.";
				}
			}
			request.setAttribute("result", result);
			String page = "/personal_project/assets/login_result.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(page);
			rd.forward(request, response);
		} // loginMember.do
		
		else if(uri.indexOf("logout.do") != -1) { // 로그아웃 처리
			// 세션객체 생성
			HttpSession session = request.getSession();
			// 세션 초기화
			session.invalidate();
		}
		
		else if (uri.indexOf("joinMember.do") != -1) {
			String result = "";
			int sqlResult;
			String userid = request.getParameter("userid");
			String passwd = request.getParameter("passwd");
			String name = request.getParameter("name");
			String ip = request.getRemoteAddr();
			Personal_project_MemberDTO dto = new Personal_project_MemberDTO();
			if (userid == null || userid.trim().equals("")) {
				result = "입력된 아이디가 없습니다.";
			} else if (passwd == null || passwd.trim().equals("")) {
				result = "입력된 비밀번호가 없습니다.";
			} else if (ip == null || ip.trim().equals("")) {
				result = "올바르지 않은 접근방법입니다.";
			} else {
				dto.setUserid(userid);
				dto.setPasswd(passwd);
				dto.setName(name);
				result = dao.joinCheck(userid);
				if (result != null) {
					result = "중복된 아이디입니다.";
				} else {
					sqlResult = dao.joinMember(dto);
					if (sqlResult == -1) {
						result = "정상적으로 처리되지 못했습니다.";
					} else {
						result += "아이디 : " + userid + "의 회원가입이 완료되었습니다.";
					}
				}
			}
			request.setAttribute("result", result);
			String page = "/personal_project/assets/print_result.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(page);
			rd.forward(request, response);
		} // join.do
		
		else if (uri.indexOf("memberList.do") != -1) {
			HttpSession session = request.getSession();
			String userid = request.getParameter("userid");
			int sesseionMember_rank = (int)session.getAttribute("member_rank");
			int requestMember_rank = Integer.parseInt(request.getParameter("member_rank"));
			if (sesseionMember_rank == requestMember_rank && sesseionMember_rank >=2) {
				int checkRank = dao.checkRank(userid);
				if (checkRank == requestMember_rank) {
					List<Personal_project_MemberDTO> memberList = dao.memberList();
					request.setAttribute("memberList", memberList);
				}
			}
			String page = "/personal_project/assets/member_list.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(page);
			rd.forward(request, response);
		} // boardList.do
		
		else if (uri.indexOf("updateMember.do") != -1) {
			int sesseionMember_rank = Integer.parseInt(request.getParameter("sesseionMember_rank"));
			String userid = request.getParameter("userid");
			String beforeUserid = request.getParameter("beforeUserid");
			String name = request.getParameter("name");
			int member_rank = Integer.parseInt(request.getParameter("member_rank"));
			if (sesseionMember_rank == 3 && member_rank <=2) {
				Personal_project_MemberDTO dto = new Personal_project_MemberDTO();
				dto.setBeforeUserid(beforeUserid);
				dto.setUserid(userid);
				dto.setName(name);
				dto.setMember_rank(member_rank);
				dao.updateMember(dto);
				List<Personal_project_MemberDTO> memberList = dao.memberList();
				request.setAttribute("memberList", memberList);
			}
			String page = "/personal_project/assets/member_list.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(page);
			rd.forward(request, response);
		} // boardList.do
		
		else if (uri.indexOf("deleteAllMember.do") != -1) {
			int result = -1;
			String resultText = "";
			result = dao.deleteAllMember();
			if (result == -1) {
				resultText = "정상적으로 처리되지 못했습니다. 중복된 아이디가 존재합니다.";
			} else {
				resultText = "kim을 제외한 모든 회원정보가 삭제되었습니다.";
			}
			System.out.println(resultText);
			request.setAttribute("resultText", resultText);
		} // deleteAllMember.do
		
		else if (uri.indexOf("boardList.do") != -1) {
			int boardListcount = dao.boardListCount();
			// 페이지 나누기를 위한 처리
			int curPage = 1;
			// 숫자 처리는 nullPointException이 자주 일어나기 때문에 if문으로 처리하는 것이 좋음
			if(request.getParameter("curPage") != null) {
				curPage = Integer.parseInt(request.getParameter("curPage"));
			}
			Pager pager = new Pager(boardListcount, curPage);
			int start = pager.getPageBegin();
			int end = pager.getPageEnd();
			
//			System.out.println("list.do called from : " + contextPath);
			List<Personal_project_BoardDTO> boardList = dao.boardList(start, end);
			// 페이지 네비게이션 출력을 위한 정보 전달
			request.setAttribute("page", pager);
			request.setAttribute("boardList", boardList);
			String page = "/personal_project/assets/board.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(page);
			rd.forward(request, response);
		} // boardList.do
		
		else if (uri.indexOf("searchBoard.do") != -1) {
			String search_option = request.getParameter("search_option");
			String keyword = request.getParameter("keyword");
			List<Personal_project_BoardDTO> boardList = dao.searchBoard(search_option, keyword);
			request.setAttribute("boardList", boardList);
			String page = "/personal_project/assets/board.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(page);
			rd.forward(request, response);
		} // searchBoard.do
		
		else if (uri.indexOf("insertBoard.do") != -1) {
			// 파일 업로드 처리
			File uploadDir = new File(Constants.UPLOAD_PATH);
			if (!uploadDir.exists()) { // 업로드 디렉토리가 존재하지 않으면 자동으로 생성
				uploadDir.mkdir(); // 디렉토리를 생성
			}
			MultipartRequest multi = new MultipartRequest(request, Constants.UPLOAD_PATH, Constants.MAX_UPLOAD, "utf-8", new DefaultFileRenamePolicy());
			String userid = multi.getParameter("userid");
			String subject = multi.getParameter("subject");
			String content = multi.getParameter("content");
			String passwd = multi.getParameter("passwd");
			String check_member = "n";
			if (multi.getParameter("check_member") != null) {
				check_member = multi.getParameter("check_member");
			}
			String ip = request.getRemoteAddr(); // 클라이언트의 ip주소
			String filename = " "; // 파일이름을 공백 1개로 초기화
			int filesize = 0;
			try {
				Enumeration files = multi.getFileNames();
				while (files.hasMoreElements()) {
					String file1 = (String)files.nextElement();
					filename = multi.getFilesystemName(file1);
					File f1 = multi.getFile(file1);
					if (f1 != null) {
						filesize = (int)f1.length(); // 파일 사이즈 저장
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			} // end try
			Personal_project_BoardDTO dto = new Personal_project_BoardDTO();
			dto.setUserid(userid);
			dto.setSubject(subject);
			dto.setContent(content);
			dto.setPasswd(passwd);
			dto.setIp(ip);
			// 파일 첨부하지 않을 경우 : trim() 문자열의 좌우 공백 제거
			if (filename == null || filename.trim().equals("")) {
				filename = "-";
			}
			dto.setFilename(filename);
			dto.setFilesize(filesize);
			dto.setCheck_member(check_member);
			dao.insertBoard(dto);
			String page = "/personal_project/index.jsp";
			response.sendRedirect(contextPath + page);
		} // insertBoard.do
		
		else if (uri.indexOf("download.do") != -1) {
			int num = Integer.parseInt(request.getParameter("num"));
			String filename = dao.getFileName(num);
			// 다운로드 할 파일 경로
			String path = Constants.UPLOAD_PATH + filename;
			byte b[] = new byte[4096]; // 바이트 배열 생성
			// 서버에 저장된 파일을 읽기 위해서 
			FileInputStream fis = new FileInputStream(path);
			// mimeType(파일의 종류 - img, mp3, text 등)
			String mimeType = getServletContext().getMimeType(path);
			if (mimeType == null) {
				mimeType = "appication/octet-stream;charset=utf-8";
			}
			/* 파일 이름에 한글이 포함된 경우 header로 값을 보내게 되는데
			 * header에는 한글이나 특수문자가 올 수 없기 때문에 톰캣서버의 기본 언어셋팅인 서유럽언어 8859_1을 utf-8로 인코딩 해야함
			 * new String(바이트배열 ("변환할인코딩값"), 기본인코딩값) 
			 */
			filename = new String(filename.getBytes("utf-8"), "8859_1");
			
			// http header setting
			response.setHeader("Content-Disposition", "attachment;filename=" + filename);
			// http body OutputStream 생성(서버에서 클라이언트에 쓰기)
			ServletOutputStream out = response.getOutputStream();
			int numRead;
			while(true) {
				numRead = fis.read(b, 0, b.length); // 데이터 읽음
				if(numRead == -1) break; // 더 이상 내용이 없으면 break;
				out.write(b, 0, numRead); // 데이터 쓰기
			} // while
			// 파일 처리 관련된 리소스 정리
			out.flush();
			out.close();
			fis.close();
			// 다운로드 횟수 증가 처리
			dao.plusDown(num);
		} // download.do
		
		else if (uri.indexOf("viewBoard.do") != -1) {
			int num = Integer.parseInt(request.getParameter("num"));
			HttpSession session = request.getSession();
			// 조회수 증가 처리
			dao.plusReadCount(num, session);
			Personal_project_BoardDTO dto = dao.viewBoardContent(num);
			request.setAttribute("dto", dto);
			String page = "/personal_project/assets/board_view.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(page);
			rd.forward(request, response);
		} // viewBoard.do
		
		else if (uri.indexOf("commentList.do") != -1) {
			int board_num = Integer.parseInt(request.getParameter("board_num"));
			List<Personal_project_CommentDTO> list = dao.commentList(board_num);
			request.setAttribute("list", list);
			String page = "/personal_project/assets/board_commentList.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(page);
			rd.forward(request, response);
		} // commentList.do
		
		else if(uri.indexOf("addComment.do") != -1) {
			Personal_project_CommentDTO dto = new Personal_project_CommentDTO();
			// 게시물 번호
			int board_num = Integer.parseInt(request.getParameter("board_num"));
			if (board_num > 11) {
				dto.setUserid(request.getParameter("userid"));
				dto.setContent(request.getParameter("content"));
				dto.setBoard_num(board_num);
				String check_member = "n";
				if (request.getParameter("check_member").indexOf("y") != -1) {
					check_member = request.getParameter("check_member");
				}
				dto.setCheck_member(check_member);
				dao.addComment(dto);
			}
			//이곳은 백그라운드로 실행되기 때문에 어디로 page이동하든 소용없다.
		} // commentAdd.do
		
		else if(uri.indexOf("addCommentReply.do") != -1) {
			int board_num = Integer.parseInt(request.getParameter("board_num"));
			int comment_num = Integer.parseInt(request.getParameter("comment_num"));
			if (board_num > 11) {
				Personal_project_CommentDTO dto = dao.commentView(comment_num);
				int comment_ref = dto.getComment_ref();
				int comment_re_step = dto.getComment_re_step() + 1; // 출력 순번
				int comment_re_level = dto.getComment_re_level() + 1; // 답변 단계
				String userid = request.getParameter("userid");
				String content = request.getParameter("content");
				String check_member = "n";
				if (request.getParameter("check_member").indexOf("y") != -1) {
					check_member = request.getParameter("check_member");
				}
				dto.setUserid(userid);
				dto.setContent(content);
				dto.setBoard_num(board_num);
				dto.setComment_ref(comment_ref);
				dto.setComment_re_step(comment_re_step);
				dto.setComment_re_level(comment_re_level);
				dto.setCheck_member(check_member);
				dao.updateCommentStep(board_num, comment_ref, comment_re_step);
				dao.addCommentReply(dto);
			}
			//이곳은 백그라운드로 실행되기 때문에 어디로 page이동하든 소용없다.
		} // addCommentReply.do
		
		
		else if (uri.indexOf("deleteAllBoard.do") != -1) {
			dao.deleteAllBoard();
			String page = "/personal_project_servlet/boardList.do";
			response.sendRedirect(contextPath + page);
		} // deleteAllBoard.do
		
		else if (uri.indexOf("boardPass_check.do") != -1) {
			// 게시물 번호
			int num = Integer.parseInt(request.getParameter("board_num"));
			String passwd = request.getParameter("passwd");
			// 비밀번호가 맞는지 확인
			String result = dao.passwdCheck(num, passwd);
			String page = "";
			if (result != null) {
				request.setAttribute("dto", dao.viewBoardContent(num));
				page = "/personal_project/assets/board_edit.jsp";
				RequestDispatcher rd = request.getRequestDispatcher(page);
				rd.forward(request, response);
			} else {
				page = contextPath + "/personal_project_servlet/viewBoard.do?num=" + num + "&message=error";
				response.sendRedirect(page);
			}
		} // boardPass_check.do
		
		else if (uri.indexOf("updateBoard.do") != -1) {
			// 파일 업로드 처리
			File uploadDir = new File(Constants.UPLOAD_PATH);
			if (!uploadDir.exists()) { // 업로드 디렉토리가 존재하지 않으면 자동으로 생성
				uploadDir.mkdir(); // 디렉토리를 생성
			}
			MultipartRequest multi = new MultipartRequest(request, Constants.UPLOAD_PATH, Constants.MAX_UPLOAD, "utf-8", new DefaultFileRenamePolicy());
			int num = Integer.parseInt(multi.getParameter("num"));
			if (num > 11) {
				String userid = multi.getParameter("userid");
				String subject = multi.getParameter("subject");
				String content = multi.getParameter("content");
				String passwd = multi.getParameter("passwd");
				String ip = request.getRemoteAddr(); // 클라이언트의 ip주소
				String filename = " "; // 파일이름을 공백 1개로 초기화
				int filesize = 0;
				try {
					Enumeration files = multi.getFileNames();
					while (files.hasMoreElements()) {
						String file1 = (String)files.nextElement();
						filename = multi.getFilesystemName(file1);
						File f1 = multi.getFile(file1);
						if (f1 != null) {
							filesize = (int)f1.length(); // 파일 사이즈 저장
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
				} // end try
				Personal_project_BoardDTO dto = new Personal_project_BoardDTO();
				dto.setNum(num);
				dto.setUserid(userid);
				dto.setSubject(subject);
				dto.setContent(content);
				dto.setPasswd(passwd);
				dto.setIp(ip);
				// 파일 첨부하지 않을 경우 : trim() 문자열의 좌우 공백 제거
				if (filename == null || filename.trim().equals("")) {
					// 새로운 첨부파일이 없을 때(테이블의 기존 정보를 가져옴)
					Personal_project_BoardDTO dto2 = dao.viewBoardContent(num);
					String fName = dto2.getFilename();
					int fSize = dto2.getFilesize();
					int fDown = dto2.getDown();
					dto.setFilename(fName);
					dto.setFilesize(fSize);
					dto.setDown(fDown);
				} else {
					dto.setFilename(filename);
					dto.setFilesize(filesize);
				}
				// 첨부파일 삭제 처리
				String fileDel = multi.getParameter("fileDel");
				// 체크박스에 체크되었으면, value없이 썼기 때문에 on이 디폴트가 됨
				if (fileDel != null && fileDel.equals("on")) {
					String fileName = dao.getFileName(num);
					File f = new File(Constants.UPLOAD_PATH + fileName);
					f.delete(); // 파일 삭제
					// 첨부파일 정보를 지움
					dto.setFilename("-");
					dto.setFilesize(0);
					dto.setDown(0);
				}
				// 레코드 수정
				dao.updateBoard(dto);
			}
			String page = "/personal_project/index.jsp";
			response.sendRedirect(contextPath + page);
		} // updateBoard.do
		
		else if(uri.indexOf("deleteBoard.do") != -1) {
			// 삭제할 게시물 번호
			int num = Integer.parseInt(request.getParameter("num"));
			if (num > 11) {
				dao.deleteBoard(num);
			}
			// 페이지 이동
			String page = "/personal_project/index.jsp";
			response.sendRedirect(contextPath + page);
		} // delete.do
		
		else if(uri.indexOf("deleteBoardByManager.do") != -1) {
			HttpSession session = request.getSession();
			int member_rank = (int)session.getAttribute("member_rank");
			// 삭제할 게시물 번호
			int num = Integer.parseInt(request.getParameter("num"));
			if (num > 11 && member_rank >= 2) {
				dao.deleteBoardByManager(num);
			}
			// 페이지 이동
			String page = "/personal_project/index.jsp";
			response.sendRedirect(contextPath + page);
		} // deleteBoardByManager.do
		
		else if(uri.indexOf("boardReply.do") != -1) {
			// 게시물 번호
			int num = Integer.parseInt(request.getParameter("num"));
			if (num > 11) {
				Personal_project_BoardDTO dto = dao.viewBoardContent(num);
				dto.setContent("====원본 게시글의 내용====\n" + dto.getContent());
				request.setAttribute("dto", dto);
			}
			String page = "/personal_project/assets/board_reply.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(page);
			rd.forward(request, response);
		} // reply.do
		
		else if(uri.indexOf("boardInsertReply.do") != -1) {
			int num = Integer.parseInt(request.getParameter("num"));
			if (num > 11) {
				Personal_project_BoardDTO dto = dao.viewBoardContent(num);
				int ref = dto.getRef(); // 답변 그룹 번호
				int re_step = dto.getRe_step() + 1; // 출력 순번
				int re_level = dto.getRe_level() + 1; // 답변 단계
				String userid = request.getParameter("userid");
				String subject = request.getParameter("subject");
				String content = request.getParameter("content");
				String passwd = request.getParameter("passwd");
				String check_member = "n";
				if (request.getParameter("check_member") != null) {
					check_member = request.getParameter("check_member");
				}
				dto.setUserid(userid);
				dto.setSubject(subject);
				dto.setContent(content);
				dto.setPasswd(passwd);
				dto.setRef(ref);
				dto.setRe_level(re_level);
				dto.setRe_step(re_step);
//				dto.setIp(request.getRemoteAddr());
				// 첨부파일 관련 정보
				dto.setFilename("-");
				dto.setFilesize(0);
				dto.setDown(0);
				dto.setCheck_member(check_member);
				// 답글 순서 조정
				dao.updateStep(ref, re_step);
				// 답글 작성
				dao.insertBoardReply(dto);
			}
			String page = "/personal_project/index.jsp";
			response.sendRedirect(contextPath + page);
		}
		
		
		
		else if (uri.indexOf("accountBook.do") != -1) {
			String userid = request.getParameter("userid");
			if (userid == null || userid.equals("")) {
				String url = "/personal_project/main.jsp";
				response.sendRedirect(request.getContextPath() + url + "?message=invalidIdError");
			} else {
				Personal_project_BoardDTO dto = new Personal_project_BoardDTO();
				dto.setUserid(userid);
				List<Personal_project_BoardDTO> list = dao.accountBookList(dto);
				request.setAttribute("list", list);
				String url = "/personal_project/assets/accountBook.jsp";
				RequestDispatcher rd = request.getRequestDispatcher(url);
				rd.forward(request, response);
			}
		} // accountBook.do
		
		else if (uri.indexOf("write.do") != -1) {
			response.sendRedirect(contextPath + "/personal_project/assets/board_write.jsp");
		} // accountBook.do
		
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
