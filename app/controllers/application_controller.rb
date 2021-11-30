class ApplicationController < ActionController::Base
    require 'csv'
    before_action :set_current_user
    def set_current_user
        # グローバル変数ではなくインスタンス変数使う
        @current_user = User.find_by(id: session[:user_id])
    end

    def authenticate_user
        if @current_user == nil #.nil?メソッド使う
            redirect_to("/")
        end
    end

    def limit_user
        if @current_user != nil #present?使う
            redirect_to("/main")
        end
    end

    def limit_word_user
        word = Word.find_by(id: params[:id])
        # どちらも/mainにリダイレクトするならifで条件分岐要らなそう
        # redirect_toの引数はpathで書くと良さそう
        # 書く場所もword_controllerかな
        if word && (@current_user.id != word.user_id)
            redirect_to("/main")
        else
            redirect_to("/main")
        end
    end

    def limit_tag_user
        # これも書く場所変えた方が良い
        tag = Tag.find_by(id: params[:id]).user_id
        if tag && (@current_user.id != tag.user_id)
            redirect_to("/main")
        end
    end

    def limit_book_user
        
    end
end
