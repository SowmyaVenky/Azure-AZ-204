package com.gssystems;

import com.azure.core.http.rest.PagedIterable;
import com.azure.storage.blob.BlobContainerClient;
import com.azure.storage.blob.BlobServiceClient;
import com.azure.storage.blob.BlobServiceClientBuilder;
import com.azure.storage.blob.models.BlobContainerItem;
import com.azure.storage.blob.models.BlobItem;

public class BlobManager 
{
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

        System.out.println("Here are the containers in the storage account ");
        PagedIterable<BlobContainerItem> containers = blobServiceClient.listBlobContainers();
        for(BlobContainerItem container : containers) {
            System.out.println("Container name = " + container.getName());

            //Now we enumerage the blobs present in each container.
            BlobContainerClient cclient =  blobServiceClient.getBlobContainerClient(container.getName());
            PagedIterable<BlobItem> blobs = cclient.listBlobs();
            for( BlobItem ablob: blobs) {
                System.out.println("Blob is: " +  ablob.getName());
            }
        }        
    }
}
