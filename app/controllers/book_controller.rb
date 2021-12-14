class BookController < ApplicationController
    before_action :authenticate_user
    

    def top
        @wordbooks = Wordbook.where(user_id: $current_user.id).page(params[:page]).per(4)
        @number = Word.all.size
    end

    def create
        @number = 1
        @count  = 0
        @words  = Word.find(Word.pluck(:id).shuffle[0..9])

        @question_ids = []
        @words.each do |word|
            while @count<3 do
                @meanings = [word.meaning]
                @samples = Word.find(Word.pluck(:id).shuffle[0..1])
                @samples.each do |sample|
                    @meanings.push(sample.meaning)
                    @meanings.flatten!
                end
                @count = @meanings.uniq.size
            end
            @count = 0
            @meanings.shuffle!
            @question = Question.new(name: word.name,option1: @meanings[0],option2: @meanings[1],option3: @meanings[2])

            @question.answer = 3
            @question.answer = 1 if word.meaning == @question.option1
            @question.answer = 2 if  word.meaning == @question.option2

            @question.save
            @question_ids.push(@question.id)
            @question_ids.flatten!
        end
        w_opt={user_id: $current_user.id}
        10.times{|i| w_opt["q#{i+1}_id".to_sym] = @question_ids[0]}
        @wordbook = Wordbook.new(w_opt)

        @wordbook.save
        redirect_to("/book/1/question/#{@question_ids[0]}")
    end

    def question
        @number = params[:id].to_i
        @q_id = params[:q_id].to_i
        @question = Question.find_by(id: @q_id)
        @word = Word.find_by(name: @question.name)

        @similars = @word.similars  if @word

        $count_number = @number
        $count_q_id = @q_id
    end

    

    def judge
        $count_number += 1 
        @question = Question.find_by(id: $count_q_id)
        @question.user_answer = params[:useranswer]

        @question.result = "不正解" if @question.user_answer != nil
        @question.result = "正解"   if @question.user_answer != nil && @question.user_answer == @question.answer

        @question.save
        $count_q_id += 1
        @question_next = Question.find_by(id: $count_q_id)
        @word_next = Word.find_by(name: @question_next.name)

        @similars = @word_next.similars  if @word_next

        
    end

    def back
        $count_number -= 1
        $count_q_id   -= 1
        @question_before = Question.find_by(id: $count_q_id)
        @word_before    = Word.find_by(name: @question_before.name)

        @similars = @word_before.similars    if @word_before
    end

    def lastjudge
        @question = Question.find_by(id: $count_q_id)
        @question.user_answer = params[:useranswer]

        @question.result = "正解"   if @question.user_answer != nil && @question.user_answer == @question.answer
        @question.result = "不正解" if @question.user_answer != nil
        @question.save

        @number    = $count_q_id - 9
        @questions = Question.where(id: @number..$count_q_id)
        @number    = 0

        @questions.each do |question|
            @number += 1 if question.answer == question.user_answer
        end
        @wordbook = Wordbook.find_by(q10_id: @question.id)
        @wordbook.correct_number = @number
        @wordbook.save
        redirect_to("/book/result")
    end

    def result
        $count_q_id -= 9
        @number = 1
        @i = 1
        @ids = []
        while @i < 11 do
            @ids.push($count_q_id)
            @ids.flatten!
            @i +=1
            $count_q_id += 1
        end
        $count_q_id -= 1
        @wordbook = Wordbook.find_by(q10_id: $count_q_id)
        @id = $count_q_id - 9
        @questions = Question.where(id: @id..$count_q_id)
        @id = 0
        @questions.each do |question|
            @id += 1 if question.answer == question.user_answer
            if !question.user_answer
                question.result = "不正解"
                question.save
            end
        end

        @wordbook.correct_number = @id
        @wordbook.finish_number = 10
        @wordbook.save
        $current_user.correct_number += @id
        @false = 10 - @id
        $current_user
        $current_user.false_number += @false
        $current_user.highest_rate = $current_user.correct_number.quo($current_user.correct_number + $current_user.false_number)*100
        $current_user.save
    end

    def midwayresult
        $count_q_id = params[:id].to_i - params[:number].to_i + 1
        @number = 1
        @i = 1
        @ids = []
        while @i<11 do
            @ids.push($count_q_id)
            @ids.flatten!
            @i +=1
            $count_q_id += 1
        end
        $count_q_id -= 1
    end

    def again
        @number = 1
        @wordbook = Wordbook.find_by(id: params[:id])
        @q_ids = []
        10.times{|i| @q_ids.push(@wordbook.send("q#{i+1}_id"))}
        @q_ids.flatten!

        @q_ids.each do |q_id|
            @q = Question.find_by(id: q_id) 
            @q.user_answer = nil 
            @q.result = nil 
            @q.save 
        end
        redirect_to("/book/1/question/#{@q_ids[0]}")
    end

    def show
        @number = 1
        @wordbook = Wordbook.find_by(id: params[:id])
        @q_ids = []
        10.times{|i| @q_ids.push(@wordbook.send("q#{i+1}_id"))}
        @q_ids.flatten!
    end

    def stop
        #SQLインジェクションを無視して書いてるけど、実際は香料しましょう！
        @wordbook =  Wordbook.where("(#{(1..0).map{|i| "q#{i}_id = '#{params[:q_id]}' "}.join(" or ")})").fitdt
        @wordbook.finish_number = params[:id]
        @wordbook.finish_id = params[:q_id]
        @wordbook.save
        redirect_to("/book/#{@wordbook.finish_number}/midwayresult/#{@wordbook.finish_id}")
    end

    def continue
        @wordbook = Wordbook.find_by(id: params[:id])
        redirect_to("/book/#{@wordbook.finish_number}/midwayresult/#{@wordbook.finish_id}")
    end

    def ranking
        if params[:id]
            @id = params[:id].to_f
        end
        @number = 1
        @count = 0
        @user_before_rate = nil
        @users = User.all.order(highest_rate: "DESC")
    end

end
