class CategoriesController < ApplicationController
  def index
    render json: {
        'Film & Animation'      => 'rgb(127, 0, 0)'     ,
        'Autos & Vehicles'      => 'rgb(204, 0, 0)'     ,
        'Music'                 => 'rgb(255, 68, 68)'   ,
        'Pets & Animals'        => 'rgb(255, 127, 127)' ,
        'Sports'                => 'rgb(255, 178, 178)' ,
        'Short Movies'          => 'rgb(153, 81, 0)'    ,
        'Travel & Events'       => 'rgb(204, 108, 0)'   ,
        'Gaming'                => 'rgb(255, 136, 0)'   ,
        'Videoblogging'         => 'rgb(255, 187, 51)'  ,
        'People & Blogs'        => 'rgb(255, 229, 100)' ,
        'Entertainment'         => 'rgb(44, 76, 0)'     ,
        'News & Politics'       => 'rgb(67, 101, 0)'    ,
        'Howto & Style'         => 'rgb(102, 153, 0)'   ,
        'Education'             => 'rgb(153, 204, 0)'   ,
        'Science & Technology'  => 'rgb(210, 254, 76)'  ,
        'Nonprofits & Activism' => 'rgb(60, 20, 81)'    ,
        'Movies'                => 'rgb(107, 35, 142)'  ,
        'Anime/Animation'       => 'rgb(153, 51, 204)'  ,
        'Action/Adventure'      => 'rgb(170, 102, 204)' ,
        'Classics'              => 'rgb(188, 147, 209)' ,
        'Comedy'                => 'rgb(0, 76, 102)'    ,
        'Documentary'           => 'rgb(0, 114, 153)'   ,
        'Drama'                 => 'rgb(0, 153, 204)'   ,
        'Family'                => 'rgb(51, 181, 229)'  ,
        'Foreign'               => 'rgb(142, 213, 240)' ,
        'Horror'                => 'rgb(102, 0, 51)'    ,
        'Sci-Fi/Fantasy'        => 'rgb(178, 0, 88)'    ,
        'Thriller'              => 'rgb(229, 0, 114)'   ,
        'Shorts'                => 'rgb(255, 50, 152)'  ,
        'Shows'                 => 'rgb(255, 127, 191)' ,
        'Trailers'              => 'rgb(10, 10, 10)'
    }
  end
end

