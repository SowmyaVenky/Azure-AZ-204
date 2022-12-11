package com.gssystems;

import com.microsoft.azure.functions.ExecutionContext;
import com.microsoft.azure.functions.HttpMethod;
import com.microsoft.azure.functions.HttpRequestMessage;
import com.microsoft.azure.functions.HttpResponseMessage;
import com.microsoft.azure.functions.HttpStatus;
import com.microsoft.azure.functions.annotation.AuthorizationLevel;
import com.microsoft.azure.functions.annotation.FunctionName;
import com.microsoft.azure.functions.annotation.HttpTrigger;

import com.azure.core.http.rest.PagedIterable;
import com.azure.storage.blob.BlobClient;
import com.azure.storage.blob.BlobContainerClient;
import com.azure.storage.blob.BlobServiceClient;
import com.azure.storage.blob.BlobServiceClientBuilder;
import com.azure.storage.blob.models.BlobContainerItem;
import com.azure.storage.blob.models.BlobItem;

import com.azure.security.keyvault.secrets.SecretClient;
import com.azure.security.keyvault.secrets.SecretClientBuilder;
import com.azure.security.keyvault.secrets.models.DeletedSecret;
import com.azure.security.keyvault.secrets.models.KeyVaultSecret;
import com.azure.identity.DefaultAzureCredentialBuilder;

import java.util.Optional;

/**
 * Azure Functions with HTTP Trigger.
 */
public class Function {
    /**
     * This function listens at endpoint "/api/HttpExample". Two ways to invoke it using "curl" command in bash:
     * 1. curl -d "HTTP Body" {your host}/api/HttpExample
     * 2. curl "{your host}/api/HttpExample?name=HTTP%20Query"
     */
    @FunctionName("HttpExample")
    public HttpResponseMessage run(
            @HttpTrigger(
                name = "req",
                methods = {HttpMethod.GET},
                authLevel = AuthorizationLevel.ANONYMOUS)
                HttpRequestMessage<Optional<String>> request,
            final ExecutionContext context) {
        context.getLogger().info("Java HTTP trigger processed a request.");

        //Getting the value of the environment var that gives us the storage account key.
        //TODO: we need to fix this to be the key-vault name instead of the entire string.
        String storageAcctKey = System.getenv("StorageConnectionString");

        //Get to the key-vault, hardcoded it is ok for testing. 
        String keyVaultName = "venkykeyvault1001";
        String keyVaultUri = "https://" + keyVaultName + ".vault.azure.net";

        SecretClient secretClient = new SecretClientBuilder()
            .vaultUrl(keyVaultUri)
            .credential(new DefaultAzureCredentialBuilder().build())
            .buildClient();

        KeyVaultSecret retrievedSecret = secretClient.getSecret("storageacctconnstring");

        BlobServiceClient blobServiceClient = new BlobServiceClientBuilder()
        .connectionString(retrievedSecret.getValue())
        .buildClient();

        StringBuffer b = new StringBuffer();

        b.append("Storage account name is: " + blobServiceClient.getAccountName());
        b.append("Storage account kind is: " + blobServiceClient.getAccountInfo().getAccountKind().name());
        b.append("Storage account sku is: " + blobServiceClient.getAccountInfo().getSkuName().name());
        b.append(enumerateContainers(blobServiceClient, "venkystorage1001"));

        if (storageAcctKey == null) {
            return request.createResponseBuilder(HttpStatus.BAD_REQUEST).body("Please configure the storageAcctKey in local.settings.json").build();
        } else {
            return request.createResponseBuilder(HttpStatus.OK).body(b.toString()).build();
        }
    }

    private static String enumerateContainers(BlobServiceClient blobServiceClient, String accountname) {
        StringBuffer b = new StringBuffer();        
        PagedIterable<BlobContainerItem> containers = blobServiceClient.listBlobContainers();
        for(BlobContainerItem container : containers) {
            b.append("Container name = " + container.getName());
            b.append(enumerateContainer(blobServiceClient, container.getName()));           
        }
        return b.toString();
    }

    private static String enumerateContainer(BlobServiceClient blobServiceClient, String containername) {
        StringBuffer b = new StringBuffer();        
        //Now we enumerage the blobs present in each container.
        BlobContainerClient cclient =  blobServiceClient.getBlobContainerClient(containername);
        PagedIterable<BlobItem> blobs = cclient.listBlobs();
        for( BlobItem ablob: blobs) {
            b.append("Blob is: " +  ablob.getName());
        }
        return b.toString();
    }
}
