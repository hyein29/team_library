package com.library.model.board;

import lombok.Data;

@Data
public class ArticleAttachDTO {

	private String uuid;
	private String upload_path;	
	private String file_name;
	private boolean file_type; 
	private Long article_no;
	
}
