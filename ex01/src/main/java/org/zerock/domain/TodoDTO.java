package org.zerock.domain;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;

@Data
public class TodoDTO {

	private String title;
	
	//http://localhost:8081/sample/ex03?title=test&dueDate=2018/01/01
	@DateTimeFormat(pattern = "yyyy/MM/dd")
	private Date dueDate;
}
