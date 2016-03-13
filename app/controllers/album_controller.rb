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



    temp_stack = []

    @image_array[0] = []
    @image_array[0] << "Getting Ready!"
    @tagged[0].each do |p|
        if p[1] == 1
          @image_array[0] << [p]
        else
          if temp_stack.length == 0
            temp_stack.push(p)
          else
            @image_array[0]  << [temp_stack.pop, p]
          end
        end

    end

    temp_stack = []

    @image_array[1] = []
    @image_array[1] << "The Bridesmaids"
    @tagged[1].each do |p|
        if p[1] == 1
          @image_array[1] << [p]
        else
          if temp_stack.length == 0
            temp_stack.push(p)
          else
            @image_array[1]  << [temp_stack.pop, p]
          end
        end
    end

    temp_stack = []


    @image_array[2] = []
    @image_array[2] << "The Groomsmen"
    @tagged[2].each do |p|
        if p[1] == 1
          @image_array[2] << [p]
        else
          if temp_stack.length == 0
            temp_stack.push(p)
          else
            @image_array[2] << [temp_stack.pop, p]
          end
        end
    end

    temp_stack = []

    @image_array[3] = []
    @image_array[3] << "The Loving Couple"
    @tagged[3].each do |p|
        if p[1] == 1
          @image_array[3] << [p]
        else
          if temp_stack.length == 0
            temp_stack.push(p)
          else
            @image_array[3] << [temp_stack.pop, p]
          end
        end
    end

    temp_stack = []

    @image_array[4] = []
    @image_array[4] << "The Ceremony"
    @tagged[6].each do |p|
        if p[1] == 1
          @image_array[4] << [p]
        else
          if temp_stack.length == 0
            temp_stack.push(p)
          else
            @image_array[4]  << [temp_stack.pop, p]
          end
        end
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
