package com.gssystems.web.controller;

//This is needed for the app config values to refresh dynamically 
import com.azure.spring.cloud.config.AppConfigurationRefresh;
import com.azure.spring.cloud.feature.manager.FeatureManager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

	private final MessageProperties properties;

	private FeatureManager featureManager;

	@Autowired(required = false)
	private AppConfigurationRefresh refresh;

	public HelloController(MessageProperties properties, FeatureManager featureManager) {
		this.properties = properties;
		this.featureManager = featureManager;
	}

	@GetMapping("/")
	public String index() {
		if (refresh != null) {
			refresh.refreshConfigurations();
		}
		
		Boolean isBetaFeatureEnabled= featureManager.isEnabledAsync("Beta").block();
		 
		return "Greetings from Spring Boot! This is the message we got from Azure App config: "
				+ properties.getMessage() + " The feature flag is: " + isBetaFeatureEnabled;
	}

}
