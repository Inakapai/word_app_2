require "csv"

class WordController < ApplicationController
    before_action :authenticate_user
    before_action :limit_word_user, {only: [:show, :edit]}
    def top
    end

    def search
        # インスタンス変数使う
        $word = ""
        $meaning = ""
        $ids = [""]
        $similar = ""
    end

    def csv
    end

    def new
        @word = Word.new
        # @similars = nil   nilなら定義しなくて良さそう
    end

    def create
        # @word = Word.new(parent_params)
        # @word.user_id = $current_user.id
        @word = @current_user.words.build(parent_params)
        @tag_ids = params[:word][:tag_ids] 
        @tag_ids = params.require(:word).permit(tag_ids: [])[:tag_ids]
        if @word.save
            @tag_ids.each do |tag_id|
                # if(tag_id != nil)
                if tag_id.present?
                    @tag_word = TagWord.new(tag_id: tag_id, word_id: @word.id)
                    @tag_word.save
                end
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
        if params[:name] && (params[:name] != "")
            # グローバル変数使わない
            $word = params[:name]
        end
        if params[:meaning] && (params[:meaning] != "")
            $meaning = params[:meaning]
        end
        if params[:tag_ids] && (params[:tag_ids] != [""])
            $ids = params[:tag_ids]
        end
        if params[:name] && (params[:similar] != "")
            $similar = params[:similar]
        end

        # if $word != ""
        if $word.present? #こちらを使う
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
            # viewで使っていないならインスタンス変数でなくローカル変数で良い
            @similar_ids = Similar.where("name like ?","%#{$similar}%").pluck(:word_id).uniq
            if @words
                @words = @words.where(id: @similar_ids)
            else
                @words = Word.where(id: @similar_ids)
            end
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
        @word = Word.find_by(id: params[:id]) # before_actionに定義
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
