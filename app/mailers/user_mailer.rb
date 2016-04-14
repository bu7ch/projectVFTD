class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.correction.subject
  #
  def correction reponse
    @reponse = reponse
    @test = Test.find(@reponse.test_id)
    @subject = 'Correction DST ' + @test.video_title
    mail to: reponse.email, subject: @subject
  end

  def acorriger reponse
    @reponse = reponse
    @test = Test.find(@reponse.test_id)
    @user = @reponse.user_username
    @subject = 'Nouveau DST de ' + @user + ' à corriger'
    mail to: "viensfairetesdevoirs@gmail.com", subject: @subject
  end
end
