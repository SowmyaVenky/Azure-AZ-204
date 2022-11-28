package com.gssytems.polyglot;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class PolyglotStorageApplication {

	public static void main(String[] args) {
		//These 2 lines are needed to allow the ssl to work with the emulator.
		//We need to remove this when we are connecting to live cosmos.
		System.setProperty("javax.net.ssl.trustStore", "NUL");
		System.setProperty("javax.net.ssl.trustStoreType", "Windows-ROOT");
		SpringApplication.run(PolyglotStorageApplication.class, args);
	}
}
