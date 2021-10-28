class NotificationMailer < ApplicationMailer

    def send_welcome_email(user)
        @user = user
        mail(to: user.email,subject: "単語帳の新規登録完了のお知らせ")
    end

end
