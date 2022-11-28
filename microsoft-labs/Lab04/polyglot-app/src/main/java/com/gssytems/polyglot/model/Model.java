package com.gssytems.polyglot.model;

import com.azure.spring.data.cosmos.core.mapping.PartitionKey;
import com.google.gson.Gson;
import com.google.gson.annotations.SerializedName;
import org.springframework.data.annotation.Id;

import java.util.List;
import java.util.UUID;

public class Model {
    @Id
    @PartitionKey
    public UUID id;

    @SerializedName("Name")
    public String name;

    @SerializedName("Category")
    public String category;

    @SerializedName("Description")
    public String description;

    @SerializedName("Products")
    public List<Product> products;

    @SerializedName("Photo")
    public String photo;

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public List<Product> getProducts() {
        return products;
    }

    public void setProducts(List<Product> products) {
        this.products = products;
    }

    public String getPhoto() {
        return photo;
    }

    public void setPhoto(String photo) {
        this.photo = photo;
    }

    public String toString() {
        Gson gs  = new Gson();
        return gs.toJson(this);
    }
}
