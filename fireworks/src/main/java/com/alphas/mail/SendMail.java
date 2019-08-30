package com.alphas.mail;

import java.util.Properties;

import javax.annotation.PostConstruct;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

@Component
public class SendMail implements Runnable{
	
	private final Logger LOGGER = LoggerFactory.getLogger(this.getClass());
	final String username = "yugender.codla@gmail.com";
    final String password = "zcyahufaehiqzgly";
    final String fromAddress = "yugender.codla@gmail.com";
    static Properties prop = null;
    Session session = null;
    
    private String aToAddress;
    private String aSubject;
    private String aContent;
    
    
	static
	{
		prop = new Properties();
		prop.put("mail.smtp.host", "smtp.gmail.com");
        prop.put("mail.smtp.port", "587");
        prop.put("mail.smtp.auth", "true");
        prop.put("mail.smtp.starttls.enable", "true"); //TLS
        
        
	}
	
	
	public SendMail() {
    	
    }

    public SendMail(String toAddress, String subject, String content) {
    	this.aToAddress = toAddress;
    	this.aSubject = subject;
    	this.aContent = content;
    }
    
    
    @Override
	public void run() {
		try {
			session = Session.getInstance(prop,
	                new javax.mail.Authenticator() {
	                    protected PasswordAuthentication getPasswordAuthentication() {
	                        return new PasswordAuthentication(username, password);
	                    }
	                });
			Message message = new MimeMessage(session);
			message.setFrom(new InternetAddress(fromAddress));
			message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(this.aToAddress +","+fromAddress));
			message.setSubject(this.aSubject);
			message.setContent(this.aContent, "text/html");
			Transport.send(message);
		} catch (MessagingException e) {
			LOGGER.error(e.getMessage(), e);
		}

	}
    

	public void send(String toAddress, String subject, String content) {
        	Runnable task = new SendMail(toAddress,subject,content);
        	new Thread(task).start();
	}

	
}
