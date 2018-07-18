class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@zineya.com'
  layout 'mailer'

  def send_feedback(feedback)
  	@feedback = feedback
    mail(:to => "bilal@zineya.com", :subject => "3wrongs Feedback")
  end
end
