class BookController < ApplicationController
    before_action :authenticate_user
    

    def top
        @wordbooks = Wordbook.where(user_id: $current_user.id).page(params[:page]).per(4)
    end

    def create
        @number = 1
        @count = 0
        @words = Word.find(Word.pluck(:id).shuffle[0..9])
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
            if word.meaning == @question.option1
                @question.answer = 1
            elsif word.meaning == @question.option2
                @question.answer = 2
            else
                @question.answer = 3
            end
            @question.save
            @question_ids.push(@question.id)
            @question_ids.flatten!
        end
        @wordbook = Wordbook.new(q1_id: @question_ids[0],
                                 q2_id: @question_ids[1],
                                 q3_id: @question_ids[2],
                                 q4_id: @question_ids[3],
                                 q5_id: @question_ids[4],
                                 q6_id: @question_ids[5],
                                 q7_id: @question_ids[6],
                                 q8_id: @question_ids[7],
                                 q9_id: @question_ids[8],
                                 q10_id: @question_ids[9],
                                 user_id: $current_user.id,
                                 )
        @wordbook.save
        redirect_to("/book/1/question/#{@question_ids[0]}")
    end

    def question
                @number = params[:id].to_i
                @q_id = params[:q_id].to_i
                @question = Question.find_by(id: @q_id)
                @word = Word.find_by(name: @question.name)
                @similars = @word.similars
                $count_number = @number
                $count_q_id = @q_id
    end

    

    def judge
        $count_number += 1 
        @question = Question.find_by(id: $count_q_id)
        @question.user_answer = params[:useranswer]
        if @question.user_answer != nil && @question.user_answer == @question.answer
            @question.result = "正解"
        elsif @question.user_answer != nil
            @question.result = "不正解"
        end
        @question.save
        $count_q_id += 1
        @question_next = Question.find_by(id: $count_q_id)
        @word_next = Word.find_by(name: @question_next.name)
        @similars = @word_next.similars

        
    end

    def back
        $count_number -= 1
        $count_q_id -= 1
        @question_before = Question.find_by(id: $count_q_id)
        @word_before = Word.find_by(name: @question_before.name)
        @similars = @word_before.similars
    end

    def lastjudge
        @question = Question.find_by(id: $count_q_id)
        @question.user_answer = params[:useranswer]
        if @question.user_answer != nil && @question.user_answer == @question.answer
            @question.result = "正解"
            @question.save
        elsif @question.user_answer != nil
            @question.result = "不正解"
            @question.save
        end
        @question.save
        @number = $count_q_id - 9
        @questions = Question.where(id: @number..$count_q_id)
        @number = 0
        @questions.each do |question|
            if question.answer == question.user_answer
                @number += 1
            end
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
        while @i<11 do
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
            if question.answer == question.user_answer
                @id += 1
            end
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
        @q_ids.push(@wordbook.q1_id)
        @q_ids.push(@wordbook.q2_id)
        @q_ids.push(@wordbook.q3_id)
        @q_ids.push(@wordbook.q4_id)
        @q_ids.push(@wordbook.q5_id)
        @q_ids.push(@wordbook.q6_id)
        @q_ids.push(@wordbook.q7_id)
        @q_ids.push(@wordbook.q8_id)
        @q_ids.push(@wordbook.q9_id)
        @q_ids.push(@wordbook.q10_id)
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
        @q_ids.push(@wordbook.q1_id)
        @q_ids.push(@wordbook.q2_id)
        @q_ids.push(@wordbook.q3_id)
        @q_ids.push(@wordbook.q4_id)
        @q_ids.push(@wordbook.q5_id)
        @q_ids.push(@wordbook.q6_id)
        @q_ids.push(@wordbook.q7_id)
        @q_ids.push(@wordbook.q8_id)
        @q_ids.push(@wordbook.q9_id)
        @q_ids.push(@wordbook.q10_id)
        @q_ids.flatten!
    end

    def stop
        if Wordbook.find_by(q1_id: params[:q_id])
            @wordbook = Wordbook.find_by(q1_id: params[:q_id])
        elsif Wordbook.find_by(q2_id: params[:q_id])
            @wordbook = Wordbook.find_by(q2_id: params[:q_id])
        elsif Wordbook.find_by(q3_id: params[:q_id])
            @wordbook = Wordbook.find_by(q3_id: params[:q_id])
        elsif Wordbook.find_by(q4_id: params[:q_id])
            @wordbook = Wordbook.find_by(q4_id: params[:q_id])
        elsif Wordbook.find_by(q5_id: params[:q_id])
            @wordbook = Wordbook.find_by(q5_id: params[:q_id])
        elsif Wordbook.find_by(q6_id: params[:q_id])
            @wordbook = Wordbook.find_by(q6_id: params[:q_id])
        elsif Wordbook.find_by(q7_id: params[:q_id])
            @wordbook = Wordbook.find_by(q7_id: params[:q_id])
        elsif Wordbook.find_by(q8_id: params[:q_id])
            @wordbook = Wordbook.find_by(q8_id: params[:q_id])
        elsif Wordbook.find_by(q9_id: params[:q_id])
            @wordbook = Wordbook.find_by(q9_id: params[:q_id])
        elsif Wordbook.find_by(q10_id: params[:q_id])
            @wordbook = Wordbook.find_by(q10_id: params[:q_id])
        end
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
        @users = User.all.order(highest_rate: "DESC")
    end

end
