require 'sinatra'
require 'sinatra/reloader'
require 'typhoeus'
require 'json'

get '/' do
  html = %q(
  <html><head><title>Movie Search</title></head><body>
  <h1>Find a Movie!</h1>
  <form accept-charset="UTF-8" action="/result" method="post">
    <label for="movie">Search for:</label>
    <input id="movie" name="movie" type="text" />
    <input name="commit" type="submit" value="Search" /> 
  </form></body></html>
  )
end

post '/result' do
  search_str = params[:movie]

  # Make a request to the omdb api here!

  response = Typhoeus.get("http://www.omdbapi.com/", :params => {:s => "#{search_str}"})
  # result = JSON.parse ("#{response}")
  result = JSON.parse(response.body)
  
  
  # result['Search'].inject("") {|x, y| x << "<a href=/poster/#{x['imdbID']}><li>#{x["Title"]} ---- #{x["Year"]}</li></a>"}

  # Modify the html output so that a list of movies is provided.
  html_str = "<html><head><title>Movie Search Results</title></head><body><h1>Movie Results</h1>\n<ul>"
  html_str += result['Search'].inject("") {|x, y| x << "<a href=/poster/#{y['imdbID']}><li>#{y["Title"]} ---- #{y["Year"]}</li></a>"}
  # "<a href=/poster/#{x['imdbID']}><li>#{x["Title"]} ---- #{x["Year"]}</li></a>"
  html_str += "</ul></body></html>"

  #the html_str is actually a cleaner way of writing multiple html codes. 


end


get '/poster/:imdb' do |imdb_id|
  picture = params[:imdb]
  # Make another api call here to get the url of the poster.
  response = Typhoeus.get("http://www.omdbapi.com/", :params => {:i => "#{picture}"})
  # # result = JSON.parse ("#{response}")
  result = JSON.parse(response.body)['Poster']



  html_str = "<html><head><title>Movie Poster</title></head><body><h1>Movie Poster</h1>\n"
  html_str = "<h3><img src = #{result}></h3>"
  html_str += '<br /><a href="/">New Search</a></body></html>'

end

