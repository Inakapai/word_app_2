class ApplicationController < ActionController::Base
    require 'csv'
    before_action :set_current_user
=begin
全体的にバグが起きやすいのでグローバル変数を使うのを辞めましょう。
基本的にはインスタンス変数を使いましょう。
$current_user → @current_user

全体的に文字列ではなきうルートのpathを書きましょう
redirect_to("/main")
=end

    def set_current_user
        $current_user = User.find_by(id: session[:user_id])
    end

    def authenticate_user
        # if $current_user == nil
        #     redirect_to("/")
        # end
        redirect_to("/") if current_user_alive?
    end

    def limit_user
        # if $current_user != nil
        #     redirect_to("/main")
        # end
        redirect_to("/main") if current_user_alive?
    end

    def limit_word_user
        # if Word.find_by(id: params[:id])
        #     if $current_user.id != Word.find_by(id: params[:id]).user_id
        #         redirect_to("/main")
        #     end
        # else
        #     redirect_to("/main")
        # end

        _word = Word.find_by(id: params[:id])
        return redirect_to("/main") unless _word
        return redirect_to("/main") if $current_user.id != _word.user_id
    end

    def limit_tag_user
        if $current_user.id != Tag.find_by(id: params[:id]).user_id
            redirect_to("/main")
        end
    end

    def limit_book_user
    end

    def current_user_alive?
        $current_user != nil
    end
end
