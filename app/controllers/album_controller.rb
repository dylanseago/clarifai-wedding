class AlbumController < ApplicationController
  def create
    photo_set = Photo.where(id: params['album-ids'].split(','))
    @photos = []
    @tagged = []
    @tags = ['Getting Ready!', 'The Bridesmaids', 'The Groomsmen', 'The Loving Couple', 'The Venue', 'The Party', 'The Ceremony']
    (0..6).each do |i|
      @tagged[i] = []
    end
    photo_set.each do |photo|
      if is_landscape?(photo)
        @tagged[photo.bucket] << [photo,0]
      else
        @tagged[photo.bucket] << [photo,1]
      end

      @photos << photo
    end
  end

  def share
    render :json => { response: 'test' }
  end

  def is_landscape? picture
    image = MiniMagick::Image.open(picture.file.path)
    image[:width] > image[:height]
  end

end
