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

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Controller
public class HomePageController {
    @Autowired
    private ModelRepository models;

    @GetMapping("/")
    public String home(Model model) {
        Iterable<com.gssytems.polyglot.model.Model> ms = models.findAll();
        List<com.gssytems.polyglot.model.Model> allm = new ArrayList<>();

        for(com.gssytems.polyglot.model.Model a: ms) {
            allm.add(a);
        }
        model.addAttribute("models", allm);
        return "home";
    }
    @GetMapping("/model")
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
