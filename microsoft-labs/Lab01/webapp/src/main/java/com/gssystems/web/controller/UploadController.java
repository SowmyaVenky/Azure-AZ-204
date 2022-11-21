package com.gssystems.web.controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

@Controller
public class UploadController {
	@GetMapping("/uploadimage")
	public String displayUploadForm() {
		return "imageupload/index";
	}

	@PostMapping("/upload")
	public String uploadImage(Model model, @RequestParam("image") MultipartFile file) throws IOException {
		StringBuilder fileNames = new StringBuilder();
		fileNames.append(file.getOriginalFilename());
		System.out.println("Image uploaded is: " + file.getName() + " is of size: " + file.getBytes().length);
		model.addAttribute("msg", "Uploaded images: " + fileNames.toString());
		return "imageupload/index";
	}
}