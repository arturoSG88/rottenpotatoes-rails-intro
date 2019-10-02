class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def index
    @all_ratings = Movie.rates.keys

    if not session[:ratings]
      session[:ratings] = Movie.rates
    end
    if not session[:sort]
      session[:sort] = "none"
    end

    if(params[:sort])
      session[:sort] = params[:sort]
    end
    if(params[:ratings])
      session[:ratings] = params[:ratings]
    end

    if(not params[:sort] or not params[:ratings])
      flash.keep
      redirect_to movies_path :sort => session[:sort], :ratings => session[:ratings]
    end

    @movies = Movie.movie_rate(session[:ratings].keys)
    @rating_checks = session[:ratings].keys

    movies_order = session[:sort]
    if(movies_order == "title")
      @movies = @movies.order(:title)
      @highlight_movie = "hilite"
    elsif (movies_order == "date")
      @movies = @movies.order(:release_date)
      @highlight_date = "hilite"
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end