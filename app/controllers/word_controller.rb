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
        @tag_ids = params.require(:word).permit(tag_ids: [])[:tag_ids]
        if @word.save
            @tag_ids.each do |tag_id|
                next unless (tag_id != nil)
                @tag_word = TagWord.new(tag_id: tag_id, word_id: @word.id)
                @tag_word.save
            end

            if params.require(:word)[:image]
                @word.image_name = "#{@word.id}.png"
                image = params.require(:word)[:image]
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


        $word   = params[:name]      if params[:name] && (params[:name] != "")
        $meaning = params[:meaning]  if params[:meaning] && (params[:meaning] != "")
        $ids     = params[:tag_ids]  if params[:tag_ids] && (params[:tag_ids] != [""])
        $similar = params[:similar]  if params[:name] && (params[:similar] != "")

        @words = Word.where("name like ?","%#{$word}%")   if $word != ""
        @words =  (@words || Word).where("meaning like ?","%#{$meaning}%")

        if $ids != [""]
            @tag_word_ids = TagWord.where(tag_id: $ids).pluck(:word_id)
            @words = (@words || Word).where(id: @tag_word_ids)
        end
        if $similar != ""
            @similar_ids = Similar.where("name like ?","%#{$similar}%").pluck(:word_id).uniq
            @words =  (@words || Word).where(id: @similar_ids)
        end
        respond_to do |format|
            format.html
            format.csv{
                bom = "\uFEFF"
                csv_data = CSV.generate(bom) do |csv|
                    if @words
                        @words.each do |word|
                            values = [word.name,word.meaning]
                            csv << values
                        end
                    end
                end
                
                send_data(csv_data,filename: "単語.csv")
                
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
                next unless (tag_id != nil && tag_id != "")
                @tag_word_solid = TagWord.find_by(tag_id: tag_id, word_id: @word.id)
                next if @tag_word_solid
                @tag_word = TagWord.new(tag_id: tag_id, word_id: @word.id)
                @tag_word.save
            end
            if params[:word][:image]
                @word.image_name = "#{@word.id}.png"
                image=params[:word][:image]
                File.delete("#{@word.image_name}")   if File.exist?("#{@word.image_name}")
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
