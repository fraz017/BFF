class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@bff.com'
  layout 'mailer'

  def send_feedback(feedback)
  	@feedback = feedback
    mail(:to => "fraz.ahsan17@gmail.com", :subject => "BFF Feedback")
  end
end
