require 'spec_helper'

describe Movie do
    it 'should return all ratings' do
      Movie.all_ratings.should == %w(G PG PG-13 NC-17 R)
    end

    it 'should find similar movies' do
      movie1 = Movie.create!(director: 'somedirector')
      movie2 = Movie.create!(director: 'somedirector')
      movie3 = Movie.create!(director: 'anotherdirector')
      Movie.similar_movies(movie1).should == [movie2]
    end
end

