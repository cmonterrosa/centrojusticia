#!/bin/env ruby
# encoding: utf-8
class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Activa tu cuenta porfavor'
    @body[:url]  = "http://#{SITE_URL}/activate/#{user.activation_code}"
  end

  def activation(user)
    setup_email(user)
    @subject    += '¡Tu cuenta ha sido activada!'
    @body[:url]  = "http://#{SITE_URL}"
  end
  
  protected
 
  def setup_email(user)
      @user = user
      @recipients = "#{user.email}"
      @from = "#{NOMBRE_OFICIAL} <elreyazucar@gmail.com>"
      @subject  = ""
      @sent_on  = Time.now
      @body[:user] = user
      @content_type = "text/html"
  end

end
