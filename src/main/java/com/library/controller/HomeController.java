package com.library.controller;

import java.io.File;
import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {

	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);

	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);

		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);

		String formattedDate = dateFormat.format(date);

		// 첨부파일 디렉토리
		String path = "C:/library_file";
		File folder = new File(path);

		// 해당 디렉토리 확인
		if (!folder.exists()) {
			try {
				folder.mkdirs(); // 폴더 생성
			} catch (Exception e) {
				e.getStackTrace();
			}
		}

		model.addAttribute("serverTime", formattedDate);

		return "home";
	}

	@GetMapping("/logout")
	public String logout(HttpServletRequest request) {

		HttpSession session = request.getSession();

		// 세션 초기화
		session.invalidate();

		return "redirect:/";

	}

	@GetMapping("/accessError")
	public String accessDenied() {

		return "/error/accessError";

	}

	@GetMapping("/accessError2")
	public String accessDenied2() {

		return "/error/accessError2";

	}

}
