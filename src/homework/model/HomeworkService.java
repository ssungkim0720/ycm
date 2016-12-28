package homework.model;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.RequestMapping;

import homework.model.pojo.HomeworkPojo;

@Component
public class HomeworkService {
	@Autowired
	SqlSessionFactory fac;
	
	public String readAnswer(int num){
		SqlSession sql = fac.openSession();
		String answer = sql.selectOne("homework.readAnswer", num);
		sql.close(); 
		return answer;
	}
	
	public HomeworkPojo read(int num){
		SqlSession sql = fac.openSession();
		HomeworkPojo pojo = sql.selectOne("homework.read", num);
		sql.close(); 
		return pojo;
	}	
	
	public List list(){
		SqlSession sql = fac.openSession();
		List list = sql.selectList("homework.list");
		sql.close();
		return list;
	}
}