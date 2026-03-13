package com.aruna.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/")
@Slf4j
public class ExampleController {

    @GetMapping("/hi")
    public ResponseEntity<String> sayHello() {
        log.info("Initiate the spring-ex2 api");
        log.warn("Initiate the spring-ex2 api");
        log.debug("Initiate the spring-ex2 api");

       return ResponseEntity.ok("say hello from spring-ex2");
    }


}
