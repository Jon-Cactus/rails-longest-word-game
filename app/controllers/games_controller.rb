require "open-uri"

class GamesController < ApplicationController
  def new
    @alphabet = ("a".."z").to_a
    @letters = []
    10.times do
      @letters << @alphabet.sample.capitalize
    end
  end

  def score
    @answer = params[:answer]
    @letters = params[:letters].split(" ") # @letters comes as an array-like string. Need to convert
    dictionary = get_dictionary(@answer)
    validate_attempt(dictionary, @answer, @letters)
  end

  private

  def get_dictionary(attempt)
    url = "https://dictionary.lewagon.com/#{attempt}"
    dictionary_serialized = URI.parse(url).read
    dictionary = JSON.parse(dictionary_serialized)
    return dictionary
  end

  def validate_attempt(dictionary, answer, letters)
    # Check if the word exists in the dictionary
    @is_english = dictionary["found"]

    letter_frequency = letters.tally
    answer_frequency = answer.upcase.chars.tally
    raise
    # Compare the occurrence of letters found in the user's answer vs. the set of letters
    # First checks if the letter exists in both hashes, then ensures that the user's answer's letters appear an equal or fewer amount of times
    @is_valid_word = answer_frequency.all? do |letter, count|
      letter_frequency[letter] && letter_frequency[letter] >= count
    end
  end
end
