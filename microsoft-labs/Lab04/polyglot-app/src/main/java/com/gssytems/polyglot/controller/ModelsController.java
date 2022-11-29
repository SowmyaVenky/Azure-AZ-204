package com.gssytems.polyglot.controller;

import com.azure.cosmos.models.PartitionKey;
import com.gssytems.polyglot.model.Model;
import com.gssytems.polyglot.repo.ModelRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;
import java.util.UUID;

@RestController
@RequestMapping(path = "/models")
public class ModelsController {

    @Autowired
    private ModelRepository models;

    public ModelsController() throws Exception {
    }

    // Upsert - create if not exists, update if exists
    @PostMapping(consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Model> create(@RequestBody Model model) {

        System.out.println("add/update " + model);

        Model saved = models.save(model);
        return new ResponseEntity<>(saved, HttpStatus.CREATED);
    }

    @GetMapping(path = "/{uuid}", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Model> getModelByUUID(@PathVariable("uuid") String uuid) {

        System.out.println("searching model " + uuid);

        Optional<Model> maybe = models.findById(UUID.fromString(uuid), new PartitionKey(uuid));
        return maybe.isPresent() ? new ResponseEntity<Model>(maybe.get(), HttpStatus.OK)
                : new ResponseEntity<>(HttpStatus.NOT_FOUND);

    }

    // replace existing item (not upsert)
    @PutMapping(consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Model> replace(@RequestBody Model model) {

        System.out.println("replacing model " + model.getId());

        Optional<Model> maybe = models.findById(model.id, new PartitionKey(model.getId()));
        if (!maybe.isPresent()) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }

        Model saved = models.save(model);
        return new ResponseEntity<>(saved, HttpStatus.OK);
    }

    @DeleteMapping(path = "/{uuid}", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Model> deleteModel(@PathVariable("uuid") String uuid) {

        System.out.println("deleting Model " + uuid);

        models.deleteById(UUID.fromString(uuid), new PartitionKey(uuid));
        return new ResponseEntity<>(HttpStatus.OK);
    }
}
