module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end

  def similar_movies_path(movie)
    "/movies/#{movie.id}/similar"
  end
end
