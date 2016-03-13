class AlbumController < ApplicationController
  def create
    photo_set = Photo.where(id: params['album-ids'].split(','))
    @photos = []
    @tagged = []

    @image_array = []


    @tags = ['Getting Ready!', 'The Bridesmaids', 'The Groomsmen', 'The Loving Couple', 'The Venue', 'The Party', 'The Ceremony']
    (0..6).each do |i|
      @tagged[i] = []
    end

    photo_set.each do |photo|

      min_counter = nil
      min_bucket = 0
      landscape = 0

      photo.buckets.each do |b|
        if min_counter == nil || @tagged[b-1].length < min_counter
          min_counter = @tagged[b-1].length
          min_bucket = b
        end
      end

      landscape = 1 if is_landscape?(photo)
      @tagged[min_bucket - 1] << [photo,landscape]

      @photos << photo
    end



    @image_array[0] = []




    (0..6).each do |j|
      @image_array[j] = []
      next if @tagged[j].length == 0

      @image_array[j] << @tagged[j][0][0]


      appending_list = []
      temp_stack = []
      @tagged[j].each_with_index do |p, i|
        next if i == 0


        if p[1] == 0
          appending_list << [p[0]]
        else
          if temp_stack.length == 0
            temp_stack.push(p[0])
          else
            appending_list << [temp_stack.pop, p[0]]
          end
        end
      end

      @image_array[j] << appending_list
    end

  puts @image_array

  end

  def share
    render :json => { response: 'Shared!' }
  end

  def is_landscape? picture
    image = MiniMagick::Image.open(picture.file.path)
    image[:width] > image[:height]
  end

end
