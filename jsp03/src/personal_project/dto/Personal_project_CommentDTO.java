package personal_project.dto;

import java.util.Date;

public class Personal_project_CommentDTO {
	private int comment_num; 
	private int board_num; 
	private String userid;
	private int comment_ref;
	private int comment_re_step;
	private int comment_re_level;
	private String content;
	private String check_member;
	private Date reg_date;
	
	public int getComment_num() {
		return comment_num;
	}
	public void setComment_num(int comment_num) {
		this.comment_num = comment_num;
	}
	public int getBoard_num() {
		return board_num;
	}
	public void setBoard_num(int board_num) {
		this.board_num = board_num;
	}
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	public int getComment_ref() {
		return comment_ref;
	}
	public void setComment_ref(int comment_ref) {
		this.comment_ref = comment_ref;
	}
	public int getComment_re_step() {
		return comment_re_step;
	}
	public void setComment_re_step(int comment_re_step) {
		this.comment_re_step = comment_re_step;
	}
	public int getComment_re_level() {
		return comment_re_level;
	}
	public void setComment_re_level(int comment_re_level) {
		this.comment_re_level = comment_re_level;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getCheck_member() {
		return check_member;
	}
	public void setCheck_member(String check_member) {
		this.check_member = check_member;
	}
	public Date getReg_date() {
		return reg_date;
	}
	public void setReg_date(Date reg_date) {
		this.reg_date = reg_date;
	}
	@Override
	public String toString() {
		return "Personal_project_CommentDTO [comment_num=" + comment_num + ", board_num=" + board_num + ", userid="
				+ userid + ", comment_ref=" + comment_ref + ", comment_re_step=" + comment_re_step
				+ ", comment_re_level=" + comment_re_level + ", content=" + content + ", check_member=" + check_member
				+ ", reg_date=" + reg_date + "]";
	}
	
	
}
