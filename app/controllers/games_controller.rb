require 'open-uri'
require 'json'
require 'time'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
    session[:letters] = @letters
  end

  def score
    @letters = session[:letters]
    condition = params[:word].upcase.chars.tally.all? { |char, count| @letters.tally[char] && count <= @letters.tally[char] }
    fetch_data = JSON.parse(URI.parse("https://dictionary.lewagon.com/#{params[:word]}").read)
    @score = "Sorry but #{params[:word].upcase} does not seem to be a valid english word.."
    if fetch_data["found"] == true && condition == true
      @score = "Congratulation! #{params[:word].upcase} is a valid English word!"
      session[:score] += (params[:word].length / 2)
    elsif condition == false
      @score = "Sorry but #{params[:word].upcase} can't be build out of #{@letters}"
    end
  end
end
