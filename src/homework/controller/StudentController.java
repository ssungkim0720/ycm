package homework.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.support.BindingAwareModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import homework.model.HomeworkService;
import homework.model.pojo.HomeworkPojo;

@Controller
@RequestMapping("/hw/student")
public class StudentController {
	@Autowired
	HomeworkService hwSvc;
	
	@RequestMapping("/writeForm")
	public String homeworkWriteForm(){
		return "/homework/writing.jsp";
	}
	@RequestMapping("/read/{num }")
	public String homeworkWrite(Map map, @PathVariable int num){
		map.put("map", hwSvc.read(num));
		return "t:hw/student";
	}
//	@RequestMapping("/read")
//	public String homeworkRead(Map map, int num){
//		map.put("list", hwSvc.read(num));
//		return "/hw/read.jsp";
//	}
	
	@RequestMapping("/readJSON")
	@ResponseBody
	public HomeworkPojo homeworkReadJSON(int num){
		HomeworkPojo pojo = hwSvc.read(num);
		return pojo;
	}	
}
