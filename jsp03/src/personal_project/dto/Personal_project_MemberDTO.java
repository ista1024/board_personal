package personal_project.dto;

import java.sql.Date;

public class Personal_project_MemberDTO {
	private int num; 
	private String userid;
	private String subject;
	private String passwd; 
	private String name;
	private int userno;
	private int member_rank;
	private Date join_date;
	private String beforeUserid;
	
	// getters and setters
	public int getNum() {
		return num;
	}
	public void setNum(int num) {
		this.num = num;
	}
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	public String getSubject() {
		return subject;
	}
	public void setSubject(String subject) {
		this.subject = subject;
	}
	public String getPasswd() {
		return passwd;
	}
	public void setPasswd(String passwd) {
		this.passwd = passwd;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public int getUserno() {
		return userno;
	}
	public void setUserno(int userno) {
		this.userno = userno;
	}
	public int getMember_rank() {
		return member_rank;
	}
	public void setMember_rank(int member_rank) {
		this.member_rank = member_rank;
	}
	public Date getJoin_date() {
		return join_date;
	}
	public void setJoin_date(Date join_date) {
		this.join_date = join_date;
	}
	public String getBeforeUserid() {
		return beforeUserid;
	}
	public void setBeforeUserid(String beforeUserid) {
		this.beforeUserid = beforeUserid;
	}
	
	
	
}
