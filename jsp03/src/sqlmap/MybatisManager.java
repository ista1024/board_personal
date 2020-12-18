package sqlmap;

import java.io.Reader;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

public class MybatisManager {
	// SqlSessionFactoryBuilder -> SqlSessionFactory -> SqlSession
	// SqlSession 객체 생성기
	private static SqlSessionFactory instance;
	
	private MybatisManager() {
		
	}
	
	/* 메소드나 생성자를 private처리할 경우 외부에서 접근이 제한됨 : new를 통해 생성할 수 없음
	 * 따라서 getInstance로 우회해서 접근하도록 코딩함
	 * 웹은 사용자들이 많기 때문에 접속할 때마다 메모리를 할당할 수 없기 때문에
	 * 다수의 인스턴스 생성을 막고 하나의 인스턴스만 생성시켜 처리한다. : 싱글톤 패턴 기법
	 */
	
	public static SqlSessionFactory getInstance() {
		
		Reader reader = null;
		try {
			// getResourceAsReader()는 Java Resourses의 src의 xml을 읽어들이는 메소드
			reader = Resources.getResourceAsReader("sqlmap/sqlMapConfig.xml");
			instance = new SqlSessionFactoryBuilder().build(reader);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (reader != null) {
					reader.close();
				}
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		} // finally
		return instance;
	} // getInstance
}

