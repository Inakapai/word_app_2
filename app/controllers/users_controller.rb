class UsersController < ApplicationController
  before_action :authenticate_user, {only: [:main]}
  before_action :limit_user, {only: [:top, :new]}

  def top
  end

  def main
  end

  def new
    @user = User.new
  end

  def create
    # ストロングパラメータ使う
    @user=User.new(name: params[:name],email: params[:email],password: params[:password],correct_number: 0,false_number:0, highest_rate:0)
    # わざわざparams[:password] != params[:c_password]しなくてもbcryptがやってくれる
     if params[:password] != params[:c_password]
      @error_message = "パスワードが確認用のものと一致しません"
      render("users/new") #pathで書く
     elsif @user.save
      session[:user_id]=@user.id
      NotificationMailer.send_welcome_email(@user).deliver_now
      redirect_to("/main")
     else
      render("users/new")
    end
    
  end

  def login
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
       session[:user_id] = @user.id
       redirect_to("/main")
    else
      @error_message = "ユーザ名又はパスワードが違います"
      render("users/top")
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to("/")
  end

end
