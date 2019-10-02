class Movie < ActiveRecord::Base
  def self.rates
    return {'G'=>1,'PG'=>1,'PG-13'=>1,'R'=>1}
  end

  def self.movie_rate(movie_ratings)
    movies = Movie.where('rating in (?)',movie_ratings)
    return movies
  end
end
