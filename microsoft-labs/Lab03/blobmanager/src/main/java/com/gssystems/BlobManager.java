package com.gssystems;

import com.azure.core.http.rest.PagedIterable;
import com.azure.storage.blob.BlobClient;
import com.azure.storage.blob.BlobContainerClient;
import com.azure.storage.blob.BlobServiceClient;
import com.azure.storage.blob.BlobServiceClientBuilder;
import com.azure.storage.blob.models.BlobContainerItem;
import com.azure.storage.blob.models.BlobItem;

public class BlobManager 
{
    private static String BASE_PATH = "C:/Venky/DP-203/SowmyaVenkyRepo/Azure-AZ-204/microsoft-labs/Lab03/blobmanager/Images/";
    private static final String BLOB_CONN_STRING = "DefaultEndpointsProtocol=http;AccountName=devstoreaccount1;AccountKey=Eby8vdM02xNOcqFlqUwJPLlmEtlCDXJ1OUzFT50uSRZ6IFsuFq2UVErCz4I6tq/K1SZFPTOtr/KBHBeksoGMGw==;BlobEndpoint=http://127.0.0.1:10000/devstoreaccount1;QueueEndpoint=http://127.0.0.1:10001/devstoreaccount1;";
    public static void main( String[] args )
    {
        System.out.println( "Connecting to Azurite to query blob information using client" );
        BlobServiceClient blobServiceClient = new BlobServiceClientBuilder()
        .connectionString(BLOB_CONN_STRING)
        .buildClient();

        System.out.println("Storage account name is: " + blobServiceClient.getAccountName());
        System.out.println("Storage account kind is: " + blobServiceClient.getAccountInfo().getAccountKind().name());
        System.out.println("Storage account sku is: " + blobServiceClient.getAccountInfo().getSkuName().name());

        //Create the containers we want.
        createContainer(blobServiceClient, "compressed-audio");
        createContainer(blobServiceClient, "vector-graphics");
        createContainer(blobServiceClient, "raster-graphics");

        createBlobInContainer(blobServiceClient, "vector-graphics", "graph.svg");
        createBlobInContainer(blobServiceClient, "raster-graphics", "graph.jpg");
   
        System.out.println("Here are the containers in the storage account ");
        enumerateContainers(blobServiceClient, blobServiceClient.getAccountName());
    }

    private static void enumerateContainers(BlobServiceClient blobServiceClient, String accountname) {
        PagedIterable<BlobContainerItem> containers = blobServiceClient.listBlobContainers();
        for(BlobContainerItem container : containers) {
            System.out.println("Container name = " + container.getName());
            enumerateContainer(blobServiceClient, container.getName());           
        }
    }

    private static void enumerateContainer(BlobServiceClient blobServiceClient, String containername) {
        //Now we enumerage the blobs present in each container.
        BlobContainerClient cclient =  blobServiceClient.getBlobContainerClient(containername);
        PagedIterable<BlobItem> blobs = cclient.listBlobs();
        for( BlobItem ablob: blobs) {
            System.out.println("Blob is: " +  ablob.getName());
        }
    }

    private static void createContainer(BlobServiceClient blobServiceClient, String containerName) {
        BlobContainerClient cclient =  blobServiceClient.getBlobContainerClient(containerName);
        cclient.deleteIfExists();
        boolean wasCreated = cclient.createIfNotExists();
        System.out.println("Was the container created : " + wasCreated);        
    }

    private static void createBlobInContainer(BlobServiceClient blobServiceClient, String containerName,  String localFile) {
        BlobContainerClient cclient =  blobServiceClient.getBlobContainerClient(containerName);        
        BlobClient blobClient = cclient.getBlobClient(localFile);    
        blobClient.uploadFromFile(BASE_PATH + localFile);        
    }
}
