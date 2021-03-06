/*
 * Creation by madmath03 the 2017-12-20.
 */

package com.monogramm.starter.api.user.listener;

import static org.junit.Assert.assertNotNull;
import static org.mockito.Matchers.any;
import static org.mockito.Matchers.anyObject;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoMoreInteractions;
import static org.mockito.Mockito.when;

import com.monogramm.starter.api.user.event.OnPasswordResetEvent;
import com.monogramm.starter.config.properties.EmailProperties;
import com.monogramm.starter.persistence.user.entity.User;
import com.monogramm.starter.persistence.user.exception.PasswordResetTokenNotFoundException;
import com.monogramm.starter.persistence.user.service.PasswordResetTokenService;

import java.util.Locale;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mockito;
import org.springframework.context.MessageSource;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;

/**
 * {@link PasswordResetListener} Unit Test.
 * 
 * @author madmath03
 */
public class PasswordResetListenerTest {

  private PasswordResetTokenService passwordResetTokenService;

  private MessageSource messages;

  private JavaMailSender mailSender;

  private EmailProperties emailProperties;

  private PasswordResetListener listener;

  /**
   * @throws java.lang.Exception if the test setup crashes.
   */
  @Before
  public void setUp() throws Exception {
    passwordResetTokenService = mock(PasswordResetTokenService.class);
    assertNotNull(passwordResetTokenService);

    messages = mock(MessageSource.class);
    assertNotNull(messages);

    mailSender = mock(JavaMailSender.class);
    assertNotNull(mailSender);

    emailProperties = new EmailProperties();
    assertNotNull(emailProperties);

    this.listener =
        new PasswordResetListener(passwordResetTokenService, messages, mailSender, emailProperties);
  }

  /**
   * @throws java.lang.Exception if the test cleanup crashes.
   */
  @After
  public void tearDown() throws Exception {
    Mockito.reset(passwordResetTokenService);
    Mockito.reset(messages);
    Mockito.reset(mailSender);
    this.emailProperties = null;

    this.listener = null;
  }

  /**
   * Test method for
   * {@link PasswordResetListener#PasswordResetListener(PasswordResetTokenService, MessageSource, JavaMailSender, EmailProperties)}.
   */
  @Test
  public void testPasswordResetListener() {
    assertNotNull(this.listener);
  }

  /**
   * Test method for
   * {@link PasswordResetListener#PasswordResetListener(PasswordResetTokenService, MessageSource, JavaMailSender, EmailProperties)}.
   */
  @Test(expected = IllegalArgumentException.class)
  public void testPasswordResetListenerNullTokenService() {
    new PasswordResetListener(null, messages, mailSender, emailProperties);
  }

  /**
   * Test method for
   * {@link PasswordResetListener#PasswordResetListener(PasswordResetTokenService, MessageSource, JavaMailSender, EmailProperties)}.
   */
  @Test(expected = IllegalArgumentException.class)
  public void testPasswordResetListenerNullMessageSource() {
    new PasswordResetListener(passwordResetTokenService, null, mailSender, emailProperties);
  }

  /**
   * Test method for
   * {@link PasswordResetListener#PasswordResetListener(PasswordResetTokenService, MessageSource, JavaMailSender, EmailProperties)}.
   */
  @Test(expected = IllegalArgumentException.class)
  public void testPasswordResetListenerNullJavaMailSender() {
    new PasswordResetListener(passwordResetTokenService, messages, null, emailProperties);
  }

  /**
   * Test method for
   * {@link PasswordResetListener#PasswordResetListener(PasswordResetTokenService, MessageSource, JavaMailSender, EmailProperties)}.
   */
  @Test(expected = IllegalArgumentException.class)
  public void testPasswordResetListenerNullEnvironment() {
    new PasswordResetListener(passwordResetTokenService, messages, mailSender, null);
  }

  /**
   * Test method for {@link PasswordResetListener#onApplicationEvent(OnPasswordResetEvent)}.
   */
  @Test
  public void testOnApplicationEvent() {
    final User user = User.builder().build();
    final Locale locale = Locale.getDefault();
    final String appUrl = "http://dummy/";
    final OnPasswordResetEvent event = new OnPasswordResetEvent(user, Locale.getDefault(), appUrl);

    // Mock
    when(passwordResetTokenService.add(anyObject())).thenReturn(true);

    final String subject = "dummy_subject";
    when(messages.getMessage("api.user.listener.reset_password_subject", null, locale))
        .thenReturn(subject);
    final String message = "dummy_message";
    when(messages.getMessage(any(String.class), any(String[].class), any(Locale.class)))
        .thenReturn(message);

    this.emailProperties.setAppTitle("My App Unit Test");
    this.emailProperties.setNoReply("no_reply@dummy.com");

    // Operation
    this.listener.onApplicationEvent(event);

    // Check
    verify(passwordResetTokenService, times(1)).add(anyObject());
    verifyNoMoreInteractions(passwordResetTokenService);

    verify(messages, times(1)).getMessage("api.user.listener.reset_password_subject", null, locale);
    verify(messages, times(2)).getMessage(any(String.class), any(String[].class),
        any(Locale.class));
    verifyNoMoreInteractions(passwordResetTokenService);

    verify(mailSender, times(1)).send(any(SimpleMailMessage.class));
    verifyNoMoreInteractions(mailSender);
  }

  /**
   * Test method for {@link PasswordResetListener#onApplicationEvent(OnPasswordResetEvent)}.
   */
  @Test(expected = PasswordResetTokenNotFoundException.class)
  public void testOnApplicationEventTokenNotAdded() {
    final User user = User.builder().build();
    final String appUrl = "http://dummy/";
    final OnPasswordResetEvent event = new OnPasswordResetEvent(user, Locale.getDefault(), appUrl);

    // Mock
    when(passwordResetTokenService.add(anyObject())).thenReturn(false);

    // Operation
    this.listener.onApplicationEvent(event);
  }

}
