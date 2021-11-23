package com.library.controller.board;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import com.library.model.board.AttachFileDTO;

import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;

@Controller
@Log4j
public class UploadController {

//	@GetMapping("/uploadForm")
//	public void uploadForm() {
//
//		log.info("upload form");
//	}


//	@PostMapping("/uploadFormAction")
//	public void uploadFormPost(MultipartFile[] uploadFile, Model model) {
//
//		String uploadFolder = "C:\\upload";
//
//		for (MultipartFile multipartFile : uploadFile) {
//
//			log.info("-------------------------------------");
//			log.info("Upload File Name: " + multipartFile.getOriginalFilename());
//			log.info("Upload File Size: " + multipartFile.getSize());
//
//			File saveFile = new File(uploadFolder, multipartFile.getOriginalFilename());
//
//			try {
//				multipartFile.transferTo(saveFile);
//			} catch (Exception e) {
//				log.error(e.getMessage());
//			} // end catch
//		} // end for
//
//	}
//
//	@GetMapping("/uploadAjax")
//	public void uploadAjax() {
//
//		log.info("upload ajax");
//	}

	
// 날짜별 폴더 생성
//	private String getFolder() {
//
//		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
//
//		Date date = new Date();
//
//		String str = sdf.format(date);
//
//		return str.replace("-", File.separator);
//	}



	private boolean checkImageType(File file) {

		try {
			String contentType = Files.probeContentType(file.toPath());

			return contentType.startsWith("image");

		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return false;
	}



	@PostMapping(value = "/uploadAjaxAction", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<AttachFileDTO>> uploadAjaxPost(MultipartFile[] uploadFile) {

		List<AttachFileDTO> list = new ArrayList<>();
		
		//저장되는 경로
		String uploadFolder = "C:\\upload";

//		String uploadFolderPath = getFolder();
		// make folder --------
		File uploadPath = new File(uploadFolder);
//		File uploadPath = new File(uploadFolder, uploadFolderPath);

		if (uploadPath.exists() == false) {
			uploadPath.mkdirs();
		}
		// make yyyy/MM/dd folder

		for (MultipartFile multipartFile : uploadFile) {

			AttachFileDTO attachDTO = new AttachFileDTO();

			String uploadFileName = multipartFile.getOriginalFilename();

			// IE has file path
			uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") + 1);
			log.info("only file name: " + uploadFileName);
			attachDTO.setFile_name(uploadFileName);
			
			UUID uuid = UUID.randomUUID();

			uploadFileName = uuid.toString() + "_" + uploadFileName;

			try {
				File saveFile = new File(uploadPath, uploadFileName);
				multipartFile.transferTo(saveFile);

				attachDTO.setUuid(uuid.toString());
				attachDTO.setUpload_path(uploadFolder);

				// check image type file
				if (checkImageType(saveFile)) {

					attachDTO.setImage(true);

					FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath, "s_" + uploadFileName));
						
					Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 100, 100);

					thumbnail.close();
				}

				// add to List
				list.add(attachDTO);

			} catch (Exception e) {
				e.printStackTrace();
			}

		} // end for
		return new ResponseEntity<>(list, HttpStatus.OK);
	}

	@GetMapping("/display")	
	@ResponseBody
	public ResponseEntity<byte[]> getFile(String file_name) {

		File file = new File(file_name);

		ResponseEntity<byte[]> result = null;

		try {
			HttpHeaders header = new HttpHeaders();

			header.add("Content-Type", Files.probeContentType(file.toPath()));
			result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file), header, HttpStatus.OK);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}

	

	@GetMapping(value = "/download", produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
	@ResponseBody
	public ResponseEntity<Resource> downloadFile(@RequestHeader("User-Agent") String userAgent, String fileName) {

		Resource resource = new FileSystemResource("c:\\upload\\" + fileName);

		if (resource.exists() == false) {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}

		String resourceName = resource.getFilename();

		// remove UUID
		String resourceOriginalName = resourceName.substring(resourceName.indexOf("_") + 1);

		HttpHeaders headers = new HttpHeaders();
		try {

			String downloadName = null;

			if ( userAgent.contains("Trident")) {
				log.info("IE browser");
				downloadName = URLEncoder.encode(resourceOriginalName, "UTF-8").replaceAll("\\+", " ");
			}else if(userAgent.contains("Edge")) {
				log.info("Edge browser");
				downloadName =  URLEncoder.encode(resourceOriginalName,"UTF-8");
			}else {
				log.info("Chrome browser");
				downloadName = new String(resourceOriginalName.getBytes("UTF-8"), "ISO-8859-1");
			}
			
			log.info("downloadName: " + downloadName);

			headers.add("Content-Disposition", "attachment; filename=" + downloadName);

		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}

		return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
	}
	
// 첨부파일 x버튼 눌렀을 때 ajax 처리과정
	@PostMapping("/deleteFile")
	@ResponseBody
	public ResponseEntity<String> deleteFile(String file_name, String type, @RequestParam("uuid") String uuid) {

		log.info("deleteFile: " + file_name);
		
		fileDelete(uuid, type);
		
		return new ResponseEntity<String>("deleted", HttpStatus.OK);

//		File file;
//		
//		try {
//						
//			file = new File("c:\\upload\\" + URLDecoder.decode(file_name, "UTF-8"));
//
//			file.delete();
//			
//			fileDelete(uuid, thumb);
//			fileDelete1(uuid);
//			if (type.equals("image")) {
//				fileDelete(uuid, type);
//
//				String largeFileName = file.getAbsolutePath().replace("s_", "");
//
//				log.info("largeFileName: " + largeFileName);
//
//				file = new File(largeFileName);
//
//				file.delete();
//				
//				fileDelete(uuid, thumb);
//			}
//		} catch (UnsupportedEncodingException e) {
//			e.printStackTrace();
//			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
//		}
//
//		return new ResponseEntity<String>("deleted", HttpStatus.OK);

	}
	
	// 폴더 내 파일삭제
	   public void fileDelete(String uuid, String type) {

	   
	      String filePath = "C:\\upload\\";
	      
	      
	      File deleteFileName = new File(filePath + uuid);
			/* File deleteThumFileName = new File(filePath + thumb); */

	      if(type.equals("image")) {
	    	  String thumb = "s_" + uuid;
	    	  File deleteThumbFileName = new File(filePath + thumb);
	          deleteFileName.delete();
	          deleteThumbFileName.delete();
	          System.out.println("파일삭제완료");

	         
	      }else {
	    	 deleteFileName.delete();
	         System.out.println("파일삭제실패");
	         
	      }
	   
	   
	   
	   }

	   
	// 첨부파일 x버튼 눌렀을 때 ajax 처리과정
		@PostMapping("/deleteFile2")
		@ResponseBody
		public ResponseEntity<String> deleteFile2(String file_name, String type,  @RequestParam("uuid") String uuid) {

			log.info("deleteFile: " + file_name);

			fileDelete(uuid, type);
			
			return new ResponseEntity<String>("deleted", HttpStatus.OK);
		}

}