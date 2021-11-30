class TagController < ApplicationController
    before_action :authenticate_user
    before_action :limit_tag_user, {only: [:show, :edit]}
    beforea_action :find_tag, only: [:show, :edit, :update, :delete]
    def top
    end

    def new
        @tag = Tag.new
    end

    def create
        #@tag = Tag.new(name: params[:tag],user_id: $current_user.id)
        @tag = @current_user.tags.build(params[:tag])
        if @tag.save
            redirect_to("/tag")#pathで書く
        else
            render("tag/new")
        end
    end

    def search
        @tags = Tag.where("name like ?","%#{params[:search]}%")
    end

    def show
        # before_actionに定義する
        #@tag = Tag.find_by(id: params[:id])
    end

    def edit
        #@tag = Tag.find_by(id: params[:id])
    end

    def update
        #@tag = Tag.find_by(id: params[:id])
        @tag.name = params[:tag]
        if @tag.save
            redirect_to("/tag")
        else
            render("tag/edit")
        end
    end

    def delete
        #@tag = Tag.find_by(id: params[:id])
        
        @tag.destroy
        redirect_to("/tag")
    end

    def find_tag
        @tag = Tag.find_by(id: params[:id])
    end

end
