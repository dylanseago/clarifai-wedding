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
      @photos << photo
      @tagged[photo.bucket - 1] << photo
    end
  end

  def share
    render :json => { response: 'test' }
  end
end
