package com.gssytems.polyglot.model;

import com.azure.spring.data.cosmos.core.mapping.PartitionKey;
import com.google.gson.Gson;
import com.google.gson.annotations.SerializedName;
import org.springframework.data.annotation.Id;

import java.util.UUID;

public class Product {
    @Id
    @PartitionKey
    public UUID id;

    @SerializedName("Name")
    public String name;

    @SerializedName("Number")
    public String number;

    @SerializedName("Category")
    public String category;

    @SerializedName("Color")
    public String color;

    @SerializedName("Size")
    public String size;

    @SerializedName("Weight")
    public double weight;

    @SerializedName("ListPrice")
    public double listPrice;

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

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public double getWeight() {
        return weight;
    }

    public void setWeight(double weight) {
        this.weight = weight;
    }

    public double getListPrice() {
        return listPrice;
    }

    public void setListPrice(double listPrice) {
        this.listPrice = listPrice;
    }

    public String getPhoto() {
        return photo;
    }

    public void setPhoto(String photo) {
        this.photo = photo;
    }

    public String toString() {
        Gson gs = new Gson();
        return gs.toJson(this);
    }
}
