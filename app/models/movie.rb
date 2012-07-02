class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end

  def self.similar_movies(movie)
    where(director: movie.director).delete_if { |i| i == movie }
  end
end
