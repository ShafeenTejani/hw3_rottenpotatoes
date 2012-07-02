require 'spec_helper'

describe MoviesController do
  describe 'index' do
    it 'should index movies' do
      get :index
      request.should render_template 'index'
    end

    it 'should redirect when sort param is different from session settings' do
      get :index, sort: "title"
      response.should redirect_to '/movies?&sort=title'
    end

    it 'should redirect when ratings param is different from session settings' do
      get :index, ratings: "G"
      response.should redirect_to movies_path ratings: "G"
    end 
  end

  describe 'show' do
    it 'should show a movie by its id' do
      movie = mock('Movie')
      Movie.should_receive(:find).with('1').and_return(movie)
      get :show, id: '1'
      assigns(:movie).should == movie
      request.should render_template 'show'
    end
  end

  describe 'find similar movies' do
    it 'should show movies by the same director' do
      movieA = mock('Movie', {:title => 'Alien', :director => 'Ridley Scott'})
      movieB = mock('Movie', {:title => 'Blade Runner', :director => 'Ridley Scott'})
      similar_movies = [movieB]
      Movie.should_receive(:find).with('1').and_return(movieA)
      Movie.should_receive(:similar_movies).with(movieA).and_return(similar_movies)
      get :similar, id: '1'
      assigns(:movies).should == similar_movies
      assigns(:movie).should == movieA
      request.should render_template 'similar'
    end

    it 'should redirect to home page if there is no director information for a movie' do
      movieA = mock('Movie', {:title => 'Alien', :director => ''})
      Movie.should_receive(:find).with('1').and_return(movieA)
      Movie.should_not_receive(:find_all_by_director)

      get :similar, id: '1'
      flash[:notice].should == "'Alien' has no director info"
      response.should redirect_to movies_path
    end
  end

  describe 'create movie' do
    it 'should create a movie given valid attributes' do
      movie = mock_model 'Movie'
      Movie.should_receive(:create!).with({"title" => "a title", "director" => "a director"}).and_return(movie)
      post :create, movie: {"title" => "a title", "director" => "a director"}
      response.should redirect_to movies_path
    end
  end

  describe 'destroy movie' do
    it 'should delete a movie' do
      movie = mock_model 'Movie'
      id = movie.id.to_s
      Movie.should_receive(:find).with(id).and_return(movie)
      movie.should_receive(:destroy)
      
      delete :destroy, id: id
      response.should redirect_to movies_path
    end
  end

  describe 'edit' do
    it 'should render edit form for movie' do
      movie = mock 'Movie'
      id = 1.to_s
      Movie.should_receive(:find).with(id).and_return(movie)
      get :edit, id: id
      request.should render_template 'edit'
    end
  end

  describe 'update' do
    it 'should update the movie with valid attrs given' do
      movie = mock_model 'Movie'
      id = movie.id.to_s
      Movie.should_receive(:find).with(id).and_return(movie)
      movie.should_receive(:update_attributes!).with({"title" => "sometitle"}).and_return(movie)
      put :update, id: id, movie: {"title" => "sometitle"}
      response.should redirect_to movie_path(id)
    end
  end

end

