class TagController < ApplicationController
    before_action :authenticate_user
    before_action :limit_user, {only: [:show, :edit, :update, :delete]}
    before_action :limit_tag_user, {only: [:show, :edit, :update, :delete]}
    def top
    end

    def new
        @tag = Tag.new
    end

    def create
        @tag = Tag.new(name: params[:tag],user_id: $current_user.id)
        if @tag.save
            redirect_to("/tag")
        else
            render("tag/new")
        end
    end

    def search
        @tags = Tag.where("name like ?","%#{params[:search]}%")
    end

    def show
        @tag = Tag.find_by(id: params[:id])
    end

    def edit
        @tag = Tag.find_by(id: params[:id])
    end

    def update
        @tag = Tag.find_by(id: params[:id])
        @tag.name = params[:tag]
        if @tag.save
            redirect_to("/tag")
        else
            render("tag/edit")
        end
    end

    def delete
        @tag = Tag.find_by(id: params[:id])
        @tag.destroy
        redirect_to("/tag")
    end

end
