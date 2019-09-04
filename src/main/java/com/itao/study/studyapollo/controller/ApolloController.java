package com.itao.study.studyapollo.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Author: JunTao
 * Date: 2019/9/2
 * Description:
 **/
@RestController
@RequestMapping("/test")
public class ApolloController {

    @Value("${study-apollo-type}")
    private String apolloType;

    @RequestMapping("/test1")
    public String test1(){
        System.out.println(apolloType);
        return apolloType;
    }
}
