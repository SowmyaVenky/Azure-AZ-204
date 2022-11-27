package com.gssytems.polyglot.repo;

import com.azure.spring.data.cosmos.repository.CosmosRepository;
import com.gssytems.polyglot.model.Model;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface ModelRepository extends CosmosRepository<Model, UUID> {
}
