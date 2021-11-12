package com.library.controller.info;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/info/*")
public class InfoController {
		
	@GetMapping("/openingHours")
	public String openingHours() {
		
		return "/info/sub2/openingHours";
	}
	
}
