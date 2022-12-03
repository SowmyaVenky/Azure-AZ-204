package com.gssytems.polyglot;

import java.io.File;

import com.azure.core.http.rest.PagedIterable;
import com.azure.storage.blob.BlobClient;
import com.azure.storage.blob.BlobContainerClient;
import com.azure.storage.blob.BlobServiceClient;
import com.azure.storage.blob.BlobServiceClientBuilder;
import com.azure.storage.blob.models.BlobContainerItem;
import com.azure.storage.blob.models.BlobItem;
import com.azure.storage.blob.models.PublicAccessType;

public class AzuriteDataLoader {
	private static final String BLOB_CONN_STRING = "DefaultEndpointsProtocol=http;AccountName=devstoreaccount1;AccountKey=Eby8vdM02xNOcqFlqUwJPLlmEtlCDXJ1OUzFT50uSRZ6IFsuFq2UVErCz4I6tq/K1SZFPTOtr/KBHBeksoGMGw==;BlobEndpoint=http://127.0.0.1:10000/devstoreaccount1;QueueEndpoint=http://127.0.0.1:10001/devstoreaccount1;";

	public static void main(String[] args) {
		if( args == null || args.length != 1 ) {
			System.out.println("Pass the images directory path as the argument");
			System.exit(-1);
		}
		System.out.println("Connecting to Azurite to query blob information using client");
		BlobServiceClient blobServiceClient = new BlobServiceClientBuilder().connectionString(BLOB_CONN_STRING)
				.buildClient();

		System.out.println("Storage account name is: " + blobServiceClient.getAccountName());
		System.out.println("Storage account kind is: " + blobServiceClient.getAccountInfo().getAccountKind().name());
		System.out.println("Storage account sku is: " + blobServiceClient.getAccountInfo().getSkuName().name());

		createContainer(blobServiceClient, "imagescontainer");
		
		File f = new File(args[0]);
		File[] imagesList = f.listFiles();
		for( File image : imagesList) {
			System.out.println("Uploading file: " + image.getAbsolutePath());
			createBlobInContainer(blobServiceClient, "imagescontainer", image.getName(), args[0]);
		}        
		enumerateContainer(blobServiceClient, "imagescontainer");
	}

	private static void createContainer(BlobServiceClient blobServiceClient, String containerName) {
		BlobContainerClient cclient = blobServiceClient.getBlobContainerClient(containerName);
		cclient.deleteIfExists();
		boolean wasCreated = cclient.createIfNotExists();
		cclient.setAccessPolicy(PublicAccessType.BLOB, null);
		System.out.println("Was the container created : " + wasCreated);
	}

	private static void createBlobInContainer(BlobServiceClient blobServiceClient, String containerName,
			String localFile, String directory) {
		BlobContainerClient cclient = blobServiceClient.getBlobContainerClient(containerName);
		BlobClient blobClient = cclient.getBlobClient(localFile);
		blobClient.uploadFromFile(directory + localFile);
	}
	
	private static void enumerateContainer(BlobServiceClient blobServiceClient, String containername) {
        //Now we enumerage the blobs present in each container.
        BlobContainerClient cclient =  blobServiceClient.getBlobContainerClient(containername);
        PagedIterable<BlobItem> blobs = cclient.listBlobs();
        for( BlobItem ablob: blobs) {
            System.out.println("Blob is: " +  ablob.getName());
        }
    }	
}
