require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    gen_let
  end

  def score
    @message = in_the_grid? ? word_is_english? : 'Sorry, your word is not in the grid. Try again!';
    final_points
  end

  private

  def gen_let
    @letters = []
    random_letters = ('A'..'Z').to_a
    random_letters.each { |_| @letters << random_letters.sample until @letters.length == 10 }
  end

  def in_the_grid?
    @letters = params[:letters].split
    letters = params[:word].upcase.chars
    (letters - @letters).empty?
  end

  def word_is_english?
    url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    response = URI.parse(url)
    json = JSON.parse(response.read)
    if json['found'] == true
      @message = 'Well done!'
    else
      @message = 'Sorry, your word is not an english word. Try again!'
    end
    @message
  end

  def final_points
    if in_the_grid? && @message == 'Well done!'
      @score = params[:word].length
      @score += 5 if params[:word].length > 3
      @score += 10 if params[:word].length > 5
    else
      @score = 0
    end
    @score
  end
end
