package com.gssystems.web.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import com.azure.storage.blob.BlobClient;
import com.azure.storage.blob.BlobContainerClient;
import com.azure.storage.blob.BlobContainerClientBuilder;
import com.gssystems.web.exception.FileStorageException;

@Service
public class BlobStorageService {
	@Value("${CONNECTION_STRING}")
	private String CONNECTION_STRING;

	//private static final String CONNECTION_STRING = "DefaultEndpointsProtocol=https;AccountName=venkystorage1001;AccountKey=zh+hXNrRHrygWNLlN5RuOembruDnorDoj8+vRCbLhnNlN95lhVm1afh6ElbKZTCq88I6SrLk/Vc4+AStShiIPg==;EndpointSuffix=core.windows.net";
	public String storeFile(MultipartFile file) {
		// Normalize file name
		String fileName = StringUtils.cleanPath(file.getOriginalFilename());

		try {
			// Check if the file's name contains invalid characters
			if (fileName.contains("..")) {
				throw new FileStorageException("Sorry! Filename contains invalid path sequence " + fileName);
			}

			 BlobContainerClient container = new BlobContainerClientBuilder()
					 .connectionString(CONNECTION_STRING)
					 .containerName("imagescontainer")
					 .buildClient();
			 
			 BlobClient blob = container.getBlobClient(fileName);
			 blob.upload(file.getInputStream(), file.getSize(), true);
			return fileName;
		} catch (Exception ex) {
			throw new FileStorageException("Could not store file " + fileName + ". Please try again!", ex);
		}
	}

}
