package org.zerock.config;

import javax.sql.DataSource;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;


@Configuration
@ComponentScan(basePackages = "org.zerock.aop")
@ComponentScan(basePackages = {"org.zerock.service"})
@EnableAspectJAutoProxy


public class RootConfig {

	
}
