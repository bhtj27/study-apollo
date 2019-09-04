package com.itao.study.studyapollo;

import com.ctrip.framework.apollo.spring.annotation.EnableApolloConfig;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@EnableApolloConfig
public class StudyApolloApplication {

    public static void main(String[] args) {
        SpringApplication.run(StudyApolloApplication.class, args);
    }

}
