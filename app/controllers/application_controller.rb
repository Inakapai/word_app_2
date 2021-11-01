class ApplicationController < ActionController::Base
    require 'csv'
    before_action :set_current_user
    before_action :limit_user
    def set_current_user
        $current_user = User.find_by(id: session[:user_id])
    end

    def authenticate_user
        if $current_user == nil
            redirect_to("/")
        end
    end

    def limit_user
        if $current_user != nil
            redirect_to("/main")
        end
    end

    def limit_word_user
        if Word.find_by(id: params[:id])
            if $current_user.id != Word.find_by(id: params[:id]).user_id
                redirect_to("/main")
            end
        else
            redirect_to("/main")
        end
    end

    def limit_tag_user
        if $current_user.id != Tag.find_by(id: params[:id]).user_id
            redirect_to("/main")
        end
    end

    def limit_book_user
        
    end
end
