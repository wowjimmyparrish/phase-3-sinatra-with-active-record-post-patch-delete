require 'pry'


class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'

  get '/games' do
    games = Game.all.order(:title).limit(10)
    games.to_json
  end

  get '/games/:id' do
    game = Game.find(params[:id])

    game.to_json(only: [:id, :title, :genre, :price], include: {
      reviews: { only: [:comment, :score], include: {
        user: { only: [:name] }
      } }
    })
  end

  delete '/reviews/:id' do
    #find the review using the id
    review = Review.find(params[:id])
    #delete the review
    review.destroy
    #send a response with the deleted review as JSON
    review.to_json
  end

  post '/reviews' do
    #use that data to create a new review in the database
    review = Review.create(
      score: params[:score],
      comment: params[:comment],
      game_id: params[:game_id],
      user_id: params[:user_id]
    )

    #send a response with newly created review as JSON
    review.to_json
  end

  patch '/reviews/:id' do
    #find the review to udate using the ID
    review = Review.find(params[:id])
    #access the data in the body of the request
    #use that data to update the review in the database
    review.update(
      score: params[:score],
      comment: params[:comment]
    )
    #send a response with updated review as JSON
    review.to_json
  end

end
