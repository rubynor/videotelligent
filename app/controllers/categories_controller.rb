class CategoriesController < ApplicationController
  def index
    render json: [
      "Film & Animation",
      "Autos & Vehicles",
      "Music",
      "Pets & Animals",
      "Sports",
      "Short Movies",
      "Travel & Events",
      "Gaming",
      "Videoblogging",
      "People & Blogs",
      "Entertainment",
      "News & Politics",
      "Howto & Style",
      "Education",
      "Science & Technology",
      "Nonprofits & Activism",
      "Movies",
      "Anime/Animation",
      "Action/Adventure",
      "Classics",
      "Comedy",
      "Documentary",
      "Drama",
      "Family",
      "Foreign",
      "Horror",
      "Sci-Fi/Fantasy",
      "Thriller",
      "Shorts",
      "Shows",
      "Trailers"
    ]
  end
end