package com.gssystems.web.controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

@Controller
public class UploadController {
	//API to push file to storage
	//private static String FILE_UPLOAD_API_ENDPOINT = "https://imagestor-api-1668993836684.azurewebsites.net/uploadFile/";
	//private static String FILE_UPLOAD_API_ENDPOINT = "http://localhost:9090/uploadFile/";
	
	@Value("${FILE_UPLOAD_API_ENDPOINT}")
	private String FILE_UPLOAD_API_ENDPOINT;
	
	@GetMapping("/uploadimage")
	public String displayUploadForm() {
		return "imageupload/index";
	}

	@PostMapping("/upload")
	public String uploadImage(Model model, @RequestParam("image") MultipartFile file) throws IOException {
		System.out.println("File Upload URL is: " + FILE_UPLOAD_API_ENDPOINT);
		StringBuilder fileNames = new StringBuilder();
		fileNames.append(file.getOriginalFilename());
		System.out.println("Image uploaded is: " + file.getOriginalFilename() + " is of size: " + file.getBytes().length);
		uploadSingleFile(file);
		model.addAttribute("msg", "Uploaded images: " + fileNames.toString());
		return "imageupload/index";
	}

	private void uploadSingleFile(MultipartFile file) throws IOException {
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.MULTIPART_FORM_DATA);

		MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
		
		String fileToUpload = file.getOriginalFilename();
	    String ext = fileToUpload.substring(fileToUpload.lastIndexOf(".") + 1);
	    String filenamenoext = fileToUpload.substring(0, fileToUpload.lastIndexOf("."));
	    Path tempFile = Files.createTempFile(filenamenoext, "." + ext);
	    Files.write(tempFile, file.getBytes());
		
		body.add("file", new FileSystemResource(tempFile.toFile()));

		HttpEntity<MultiValueMap<String, Object>> requestEntity = new HttpEntity<>(body, headers);
		RestTemplate restTemplate = new RestTemplate();
		ResponseEntity<String> response = restTemplate.postForEntity(FILE_UPLOAD_API_ENDPOINT, requestEntity, String.class);
		System.out.println("Response code: " + response.getStatusCode());
	}

}