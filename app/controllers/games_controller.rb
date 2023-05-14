require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.sample(10)
  end

  def score
    @guess = params[:guess]
    if in_the_grid?(@guess, params[:letters])
      if a_word?(@guess)
        @result = "Congratulations, #{@guess} is a valid English word!"
        calculate_score(@guess)
      else
        @result = "Sorry but #{@guess} doesn't seem to be a word"
        @score = 0
      end
    else
      @result = "Sorry but #{@guess} can't be built out of #{params[:letters]}"
      @score = 0
    end
  end

  def a_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    wagon_hash = URI.open(url).read
    wagon_dict = JSON.parse(wagon_hash)
    wagon_dict['found']
  end

  def in_the_grid?(guess, grid)
    guess.chars.all? { |letter| grid.include?(letter.upcase) }
  end

  def calculate_score(word)
    @score = word.length
  end
end
