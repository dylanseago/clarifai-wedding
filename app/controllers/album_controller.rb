class AlbumController < ApplicationController
  def create
    photo_set = Photo.where(id: params['album-ids'].split(','))
    @photos = []
    @tagged = []
    (0..6).each do |i|
      @tagged[i] = []
    end
    photo_set.each do |photo|
      @photos << photo
      @tagged[photo.bucket] << photo
    end
  end
end
