package com.library.service.mylib;

import java.util.List;

import com.library.model.mylib.NoteBookRoomDTO;

public interface NotebookRoomService {

	/* 전체 좌석 조회 */
	public List<NoteBookRoomDTO> nb_list_all();
	
	
	
	
	
	
	
	
	/* Notebook Room 좌석 setting */
	public void insert(int seat_no);
	
}
