package com.gssystems.functions;

import com.microsoft.azure.functions.ExecutionContext;
import com.microsoft.azure.functions.HttpMethod;
import com.microsoft.azure.functions.HttpRequestMessage;
import com.microsoft.azure.functions.HttpResponseMessage;
import com.microsoft.azure.functions.HttpStatus;
import com.microsoft.azure.functions.annotation.AuthorizationLevel;
import com.microsoft.azure.functions.annotation.BlobInput;
import com.microsoft.azure.functions.annotation.FunctionName;
import com.microsoft.azure.functions.annotation.HttpTrigger;
import com.microsoft.azure.functions.annotation.StorageAccount;

import java.util.Optional;

/**
 * Azure Functions with HTTP Trigger.
 */
public class Function {
    //This annotation will make sure that it will use the values from  local.settings.json with the 
    // "AzureWebJobsStorage": "UseDevelopmentStorage=true"
    @StorageAccount("AzureWebJobsStorage")
    @FunctionName("GetSettings")     
    public HttpResponseMessage getSettings(
            @HttpTrigger(
                name = "req",
                methods = {HttpMethod.GET, HttpMethod.POST},
                authLevel = AuthorizationLevel.ANONYMOUS)
                HttpRequestMessage<Optional<String>> request,
            @BlobInput(
                name = "settingsblob", 
                path = "content/settings.json")
            String json,
            final ExecutionContext context) {
        context.getLogger().info("Got the http trigger, will return the blob contents at content/settings.json.");
        return request.createResponseBuilder(HttpStatus.OK).body(json).build();
    }
}
