package com.gssytems.polyglot.webcontroller;

import com.azure.cosmos.models.PartitionKey;
import com.gssytems.polyglot.repo.ModelRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Optional;
import java.util.UUID;

@Controller
public class HomePageController {
    @Autowired
    private ModelRepository models;

    @GetMapping("/home")
    public String mainWithParam(
            @RequestParam(name = "id", required = true, defaultValue = "")
                    String id, Model model) {
        model.addAttribute("id", id);
        System.out.println("searching model " + id);

        Optional<com.gssytems.polyglot.model.Model> maybe = models.findById(UUID.fromString(id), new PartitionKey(id));
        if( maybe.isPresent()){
            model.addAttribute("modeldata", maybe.get());
        }

        return "model";
    }
}
