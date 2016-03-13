class AlbumController < ApplicationController
  def create


    photo_set = Photo.where(id: params['album-ids'].split(','))
    puts 'HEEEEEEEREEEEEE'
    puts params['album-ids']
    puts params['album-ids']
    puts photo_set.length
    @photos = []
    photo_set.each do |photo|
      get_tags(photo)
      @photos << photo
    end
  end

  def result
  end



=begin
  def bucket_tag_old(tag_list)
    bucket = 0
    if tag_list['fashion'] > 0.8 or tag_list['jewelry'] > 0.8 or tag_list['getting ready'] > 0.8 or tag_list['rings'] > 0.8 or tag_list['invitations'] > 0.8 or tag_list['bedroom'] > 0.8
      bucket = 1
    elsif tag_list['food'] > 0.8 or tag_list['wedding party'] > 0.8
      bucket = 5
    elsif tag_list['reception'] > 0.8 or tag_list['decor'] > 0.8 or tag_list['table'] > 0.8 or tag_list['flowers'] > 0.8 or tag_list['bouquet'] > 0.8
      bucket = 6
    elsif tag_list['ceremony'] > 0.8 or tag_list['vows'] > 0.8 or tag_list['ring bearer'] > 0.8
      bucket = 7
    elsif tag_list['bridesmaids'] > 0.9 or (tag_list['bride'] > 0.9 and tag_list['groom'] < 0.9)
      bucket = 2
    elsif tag_list['groomsmen'] > 0.9 or (tag_list['groom'] > 0.9 and tag_list['bride'] < 0.9)
      bucket = 3
    elsif tag_list['bride'] > 0.9 and tag_list['groom'] > 0.9
      bucket = 4
    end
    bucket
  end
=end

end
