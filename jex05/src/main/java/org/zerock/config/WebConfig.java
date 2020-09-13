package org.zerock.config;

import javax.servlet.Filter;
import javax.servlet.MultipartConfigElement;
import javax.servlet.ServletRegistration;
import javax.servlet.ServletRegistration.Dynamic;

import org.springframework.web.filter.CharacterEncodingFilter;
import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;

public class WebConfig extends AbstractAnnotationConfigDispatcherServletInitializer{

	@Override
	protected Class<?>[] getRootConfigClasses() {
		// TODO Auto-generated method stub
		return new Class[] {RootConfig.class};
	}

	@Override
	protected Class<?>[] getServletConfigClasses() {
		// TODO Auto-generated method stub
		return new Class[] {ServletConfig.class};
	}

	@Override
	protected String[] getServletMappings() {
		// TODO Auto-generated method stub
		return new String[] {"/"};	// 기본 경로 설정
	}

	//404에러 처리
	@Override
	protected void customizeRegistration(ServletRegistration.Dynamic registration) {
		// TODO Auto-generated method stub
		registration.setInitParameter("throwExceptionIfNoHandlerFound", "true");
		
		//파일 업로드 처리
		MultipartConfigElement multipartConfig = new MultipartConfigElement("C:\\upload\\temp", 20971520, 41943040, 20971520);
		
		registration.setMultipartConfig(multipartConfig);
	}
	
	@Override
	  protected Filter[] getServletFilters() {
	    CharacterEncodingFilter characterEncodingFilter = new CharacterEncodingFilter();
	      characterEncodingFilter.setEncoding("UTF-8");
	      characterEncodingFilter.setForceEncoding(true);

	      return new Filter[] { characterEncodingFilter };
	  }
}
