class CategoriesController < ApplicationController
  def index
    render json: [
        { name: 'Film & Animation',      color: 'rgb(127, 0, 0)'     },
        { name: 'Autos & Vehicles',      color: 'rgb(204, 0, 0)'     },
        { name: 'Music',                 color: 'rgb(255, 68, 68)'   },
        { name: 'Pets & Animals',        color: 'rgb(255, 127, 127)' },
        { name: 'Sports',                color: 'rgb(255, 178, 178)' },
        { name: 'Short Movies',          color: 'rgb(153, 81, 0)'    },
        { name: 'Travel & Events',       color: 'rgb(204, 108, 0)'   },
        { name: 'Gaming',                color: 'rgb(255, 136, 0)'   },
        { name: 'Videoblogging',         color: 'rgb(255, 187, 51)'  },
        { name: 'People & Blogs',        color: 'rgb(255, 229, 100)' },
        { name: 'Entertainment',         color: 'rgb(44, 76, 0)'     },
        { name: 'News & Politics',       color: 'rgb(67, 101, 0)'    },
        { name: 'Howto & Style',         color: 'rgb(102, 153, 0)'   },
        { name: 'Education',             color: 'rgb(153, 204, 0)'   },
        { name: 'Science & Technology',  color: 'rgb(210, 254, 76)'  },
        { name: 'Nonprofits & Activism', color: 'rgb(60, 20, 81)'    },
        { name: 'Movies',                color: 'rgb(107, 35, 142)'  },
        { name: 'Anime/Animation',       color: 'rgb(153, 51, 204)'  },
        { name: 'Action/Adventure',      color: 'rgb(170, 102, 204)' },
        { name: 'Classics',              color: 'rgb(188, 147, 209)' },
        { name: 'Comedy',                color: 'rgb(0, 76, 102)'    },
        { name: 'Documentary',           color: 'rgb(0, 114, 153)'   },
        { name: 'Drama',                 color: 'rgb(0, 153, 204)'   },
        { name: 'Family',                color: 'rgb(51, 181, 229)'  },
        { name: 'Foreign',               color: 'rgb(142, 213, 240)' },
        { name: 'Horror',                color: 'rgb(102, 0, 51)'    },
        { name: 'Sci-Fi/Fantasy',        color: 'rgb(178, 0, 88)'    },
        { name: 'Thriller',              color: 'rgb(229, 0, 114)'   },
        { name: 'Shorts',                color: 'rgb(255, 50, 152)'  },
        { name: 'Shows',                 color: 'rgb(255, 127, 191)' },
        { name: 'Trailers',              color: 'rgb(10, 10, 10)'    }
    ]
  end
end

