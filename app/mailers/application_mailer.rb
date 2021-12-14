class ApplicationMailer < ActionMailer::Base
  #fromはenv別の定数に定義しましょう！
  default from: "管理人<y.iwamo223@gmail.com>"
  layout 'mailer'
end
