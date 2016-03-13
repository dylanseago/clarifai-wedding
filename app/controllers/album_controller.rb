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
      min_counter = nil
      min_bucket = 0

      photo.buckets.each do |b|
        if min_counter == nil || @tagged[b-1].length < min_counter
          min_counter = @tagged[b-1].length
          min_bucket = b
        end
      end

      if is_landscape?(photo)
        @tagged[min_bucket - 1] << [photo,0]
      else
        @tagged[min_bucket - 1] << [photo,1]
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
