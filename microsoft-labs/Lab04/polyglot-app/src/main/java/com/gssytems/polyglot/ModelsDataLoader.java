package com.gssytems.polyglot;

import com.google.gson.Gson;
import com.gssytems.polyglot.model.Model;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.web.client.RestTemplate;

import java.io.FileReader;
import java.util.List;

public class ModelsDataLoader {
    private static final String MODELS_FILE_NAME = "C:\\Venky\\DP-203\\Azure-AZ-204\\microsoft-labs\\Lab04\\models.json";
    public static void main(String[] args) throws Exception {
        System.setProperty("javax.net.ssl.trustStore", "NUL");
        System.setProperty("javax.net.ssl.trustStoreType", "Windows-ROOT");
        System.out.println("Reading the models file to load into cosmos");
        Gson gs = new Gson();
        FileReader fr = new FileReader(MODELS_FILE_NAME);
        List<Object> datarows = gs.fromJson(fr, List.class);
        System.out.println(datarows.size() + " rows of data found!");

        RestTemplate restTemplate = new RestTemplate();

        for(Object m: datarows) {
            String jsonData = gs.toJson(m);
            Model amodel = gs.fromJson(jsonData, Model.class);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            HttpEntity<Model> request = new HttpEntity<Model>(amodel, headers);
            Model returned = restTemplate.postForObject("http://localhost:8080/models", request, Model.class);
            System.out.println(returned.products);
        }
    }
}
