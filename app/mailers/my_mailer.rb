class MyMailer < Devise::Mailer
  default :from => 'vista@iimb.ernet.in'   
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views

  def thank_you(user)
  	mail(:from => "vista@iimb.ernet.in", :to => user.email, :subject => "Vista2015 Registration Success")
  end

  def referral_mail(user)
  	@resource=user
  	mail(:from => "vista@iimb.ernet.in", :to => user.email, :subject => "Welcome 2 Vista2015 ! ")
  end
end