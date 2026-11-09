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
    # Prepare a hash to compare the occurrence of letters between the user's answer and the provided letters
    frequency = { letters: {}, answer: {}}
    # Iterate through letters and push them into the frequency hash
    letters.each do |letter|
      frequency[:letters][letter] ?
      frequency[:letters][letter] += 1 :
      frequency[:letters][letter] = 1
    end
    # Iterate through the user's answer and push them into the frequency hash
    answer.split("").each do |letter|
      frequency[:answer][letter.capitalize] ?
      frequency[:answer][letter.capitalize] += 1 :
      frequency[:answer][letter.capitalize] = 1
    end
    # Compare the occurrence of letters found in the user's answer vs. the set of letters
    # First checks if the letter exists in both hashes, then ensures that the user's answer's letters appear an equal or fewer amount of times
    @is_valid_word = frequency[:answer].all? {|letter, count| frequency[:letters][letter] && frequency[:letters][letter] >= count}
  end
end
