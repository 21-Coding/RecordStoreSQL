require('sinatra')
require('sinatra/reloader')
require('./lib/album')
require('./lib/song')
require('./lib/artist')
require('pry')
require("pg")

also_reload('lib/**/*.rb')

DB = PG.connect({:dbname => "record_store"})

get('/') do
  @albums = Album.all
  erb(:albums)
end

get('/albums') do
  if params["clear"]
    @albums = Album.clear()
  elsif params["search_input"]
    @albums = Album.search(params["search_input"])
  elsif params["sort_list"]
    @albums = Album.sort()
  else
    @albums = Album.all
  end
  erb(:albums)
end

get('/albums/new') do
  erb(:new_album)
end

get('/albums/:id') do
  @album = Album.find(params[:id].to_i())
  erb(:album)
end

post('/albums') do
  name = params[:album_name]
  year = params[:album_year]
  genre = params[:album_genre]
  artist = params[:album_artist]
  album = Album.new(:name => name, :id => nil, :year => year, :genre => genre, :artist => artist, :status => nil)
  album.save()
  @albums = Album.all
  erb(:albums)
end


get('/albums/:id/edit') do
  @album = Album.find(params[:id].to_i())
  erb(:edit_album)
end

patch('/albums/:id') do
  if !params[:name] && !params[:year] && !params[:genre] && !params[:artist]
    @album = Album.find(params[:id].to_i())
    @album.sold()
    @albums = Album.all
  else
    @album = Album.find(params[:id].to_i())
    @album.update(:name => params[:name], :year => params[:year], :genre => params[:genre], :artist => params[:artist])
    # @album = Album.add_search
    @albums = Album.all
  end
  erb(:album)

end

delete('/albums/:id') do
  @album = Album.find(params[:id].to_i())
  @album.delete()
  @albums = Album.all
  erb(:albums)
end

get('/albums/search/') do
  @album = Album.search(params[:searched])
  erb(:search)
end

get('/albums/:id/songs/:song_id') do
  @song = Song.find(params[:song_id].to_i())
  erb(:song)
end

post('/albums/:id/songs') do
  @album = Album.find(params[:id].to_i())
  song = Song.new(:name => params[:song_name], :album_id => @album.id, :id => nil)
  song.save()
  erb(:album)
end

patch('/albums/:id/songs/:song_id') do
  @album = Album.find(params[:id].to_i())
  song = Song.find(params[:song_id].to_i())
  song.update(:name => params[:name], :album_id => @album.id)
  erb(:album)
end

delete('/albums/:id/songs/:song_id') do
  song = Song.find(params[:song_id].to_i())
  song.delete
  @album = Album.find(params[:id].to_i())
  erb(:album)
end

get('/artists') do
  if params["clear"]
    @artists = Artist.clear()
  elsif params["search_input"]
    @artists = Artist.search(params["search_input"])
  elsif params["sort_list"]
    @artists = Artist.sort()
  else
    @artists = Artist.all
  end
  erb(:artists)
end

get('/artists/:id') do
  @artist = Artist.find(params[:id].to_i())
  erb(:artists)
end

post('/artists') do
  name = params[:album_name]
  artist = Artist.new(name, nil)
  artist.save()
  @artists = Artist.all()
  erb(:artists)
end

patch('/artists/:id') do
@artist  = Artist.find(params[:id].to_i())
@artist.update(params[:name])
@artists = Artist.all
erb(:artist)
end

delete('/artists/:id') do
  @artist = Artist.find(params[:id].to_i())
  @artist.delete()
  @artists = Artist.all
  erb(:artists)
end
