require 'open-uri'

class GamesController < ApplicationController
  def new
    vowels = %w[A E I O U]
    all_letters = ('A'..'Z').to_a
    consonants = all_letters - vowels
    @letters = vowels.sample(3)
    @letters += consonants.sample(7)
    @letters.shuffle!
  end

  def score
    @word = params[:word].upcase
    @letters = params[:letters].split
    @included = included?(@word, @letters)
    @english_word = english_word?(@word)
    @score = @word.size
    @time = '10 seconds'
  end
end

private

def included?(word, letters)
  word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
end

def english_word?(word)
  response = open("https://wagon-dictionary.herokuapp.com/#{word}")
  json = JSON.parse(response.read)
  json['found']
end

def compute_score(word, time_taken)
  time_taken > 60.0 ? 0 : word.size * (1.0 - time_taken / 60.0)
end
