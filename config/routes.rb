Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  
  get "main" => "users#main" 
  get "signup" => "users#new"
  post "posts/create" => "users#create"
  post "posts/login" => "users#login"
  get "logout" => "users#logout"

  get "tag" => "tag#top"
  get "tag/new" => "tag#new"
  post "tag/create" => "tag#create"
  post "tag/search" => "tag#search"
  get "tag/:id" => "tag#show"
  get "tag/:id/edit" => "tag#edit"
  post "tag/:id/update" => "tag#update"
  post "tag/:id/delete" => "tag#delete"

  get "word" => "word#top"
  get "word/search" => "word#search"
  get "word/result" => "word#result"
  post "word/result" => "word#result"
  get "word/new" => "word#new"
  get "word/:id/similar" => "word#similar"
  post "word/:id/similar_create" => "word#similar_create"
  post "word/create" => "word#create"
  get "word/:id/edit" => "word#edit"
  post "word/:id/update" => "word#update"
  patch "word/:id/update" => "word#update"
  post "word/:id/delete" => "word#delete"
  get "word/:id" => "word#show"

  get "book/ranking" => "book#ranking"
  get "book" => "book#top"
  get "book/create" => "book#create"
  get "book/:id/question/:q_id" => "book#question"
  get "book/:id/lastquestion/q_id" => "book#lastquestion"
  post "book/back" => "book#back"
  post "book/judge" => "book#judge"
  post "book/lastjudge" => "book#lastjudge"
  get "book/result" => "book#result"
  get "book/:id/again" => "book#again"
  get "book/:id/show" => "book#show"
  get "book/:id/stop/:q_id" => "book#stop"
  get "book/:id/continue" => "book#continue"
  get "book/:number/midwayresult/:id" => "book#midwayresult"
  get "book/:id/ranking" => "book#ranking"
  
  get "/" => "users#top"
   
end
