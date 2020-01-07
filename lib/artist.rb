class Artist
  attr_reader :id, :name
  attr_accessor :name


  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  def self.all
    returned_artist = DB.exec("SELECT * FROM artists;")
    artists = []
    returned_artist.each() do |artist|
      name = artist.fetch("name")
      id = artist.fetch("id").to_i
      artists.push(Artist.new({:name => name, :id => id}))
    end
    artists
  end


def self.clear
  DB.exec("DELETE FROM artists *;")
end

def self.find(id)
  artist = DB.exec("SELECT * FROM artists WHERE id = #{id};").first
  name = artist.fetch("name")
  id = artist.fetch("id").to_i
  Artist.new({:name => name, :id => id})
end

def save
  result = DB.exec("INSERT INTO artists (name) VALUES ('#{@name}') RETURNING id;")
  @id = result.first().fetch("id").to_i
end

def ==(artist_to_compare)
  self.name().downcase().eql?(artist_to_compare.name.downcase()) 
  # && self.a().downcase().eql?(artist_to_compare.artist.downcase())
end

def delete
 DB.exec("DELETE FROM artists WHERE id = #{@id};")
 DB.exec("DELETE FROM songs WHERE artist_id = #{@id};")
end

end
