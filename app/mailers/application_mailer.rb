class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@zineya.com'
  layout 'mailer'

  def send_feedback(feedback)
  	@feedback = feedback
    mail(:to => "fraz.ahsan17@gmail.com", :subject => "Zineya Feedback")
  end
end
