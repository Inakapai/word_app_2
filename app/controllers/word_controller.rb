require "csv"

class WordController < ApplicationController
    before_action :authenticate_user
    before_action :limit_word_user, {only: [:show, :edit]}
    def top
    end

    def search
        $word = ""
        $meaning = ""
        $ids = [""]
        $similar = ""
    end

    def csv
    end

    def new
        @word = Word.new
        @similars = nil
    end

    def create
        @word = Word.new(parent_params)
        @word.user_id = $current_user.id
        @tag_ids = params[:word][:tag_ids]
        if @word.save
            @tag_ids.each do |tag_id|
                if(tag_id != nil)
                    @tag_word = TagWord.new(tag_id: tag_id, word_id: @word.id)
                    @tag_word.save
                end
            end
            if params.require(:word)[:image]
                @word.image_name = "#{@word.id}.png"
                image=params.require(:word)[:image]
                File.binwrite("public/word_images/#{@word.image_name}",image.read)
                @word.save
            end
            redirect_to("/word")
        else
            render("word/new")
        end
    end



    def similar
        @word = Word.new
        @tag = Tag.all
        @id = params[:id]
    end


    def result
        if params[:name] != ""
            $word = params[:name]
        end
        if params[:meaning] != ""
            $meaning = params[:meaning]
        end
        if params[:tag_ids] != [""]
            $ids = params[:tag_ids]
        end
        if params[:similar] != ""
            $similar = params[:similar]
        end

        if $word != ""
            @words = Word.where("name like ?","%#{$word}%")
        end
        if $meaning != ""
            if @words
                @words = @words.where("meaning like ?","%#{$meaning}%")
            else
                @words = Word.where("meaning like ?","%#{$meaning}%")
            end
        end
        if $ids != [""]
            @tag_word_ids = TagWord.where(tag_id: $ids).pluck(:word_id)
            if @words
                @words = @words.where(id: @tag_word_ids)
            else
                @words = Word.where(id: @tag_word_ids)
            end
        end
        if $similar != ""
            @similar_ids = Similar.where("name like ?","%#{$similar}%").pluck(:word_id).uniq
            if @words
                @words = @words.where(id: @similar_ids)
            else
                @words = Word.where(id: @similar_ids)
            end
            
        end
        respond_to do |format|
            format.html{
                
            }
            format.csv{
                csv_data = CSV.generate do |csv|
                    if $word != ""
                        @word_names.each do |word_name|
                            values = [word_name.name, word_name.meaning]
                            csv << values
                        end
                    end
                    if $meaning != ""
                        @word_meanings.each do |word_meaning|
                            values = [word_meaning.name, word_meaning.meaning]
                            csv << values
                        end
                    end
                end
                send_data(csv_data, filename: "単語.csv")
            }
        end

    end

    

    
    

    def show
        @word = Word.find_by(id: params[:id])
    end

    def edit
        @word = Word.find_by(id: params[:id])
        @similars = Similar.where(word_id: @word.id)
        @datas = []
        @tag_words = TagWord.where(word_id: params[:id])
        @tag_words.each do |tag_word|
            @id = tag_word.tag_id
            @datas.push(@id)
            @datas.flatten!
        end

    end

    def update
        @word = Word.find_by(id: params[:id])
        @word.update(parent_params)
        @word.user_id = $current_user.id
        @tag_ids = params[:word][:tag_ids]
        @tag_word_delete = TagWord.where(word_id: @word.id)
        @tag_word_delete.each do |tag_word_delete| 
            if !@tag_ids.include?(tag_word_delete.id)
                tag_word_delete.destroy
            end
        end
        if @word.save
            @tag_ids.each do |tag_id|
                if(tag_id != nil && tag_id != "")
                    @tag_word_solid = TagWord.find_by(tag_id: tag_id, word_id: @word.id)
                    if !@tag_word_solid 
                        @tag_word = TagWord.new(tag_id: tag_id, word_id: @word.id)
                        @tag_word.save
                    end
                end
            end
            if params[:word][:image]

                @word.image_name = "#{@word.id}.png"
                image=params[:word][:image]
                if File.exist?("#{@word.image_name}")
                    File.delete("#{@word.image_name}")
                end
                File.binwrite("public/word_images/#{@word.image_name}",image.read)
                @word.save
            end
            redirect_to("/word")
        else
            render("word/edit")
        end

    end

    def delete
        @word = Word.find_by(id: params[:id])
        @word.destroy
        redirect_to("/word")
    end

    def result_similar

    end

    private
    def parent_params
        params.require(:word).permit(:name, :meaning, similars_attributes: [:id, :name, :_destroy])
    end

    



end
