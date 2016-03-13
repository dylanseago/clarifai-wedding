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

  def get_tags(photo)

    return photo.tag if photo.tag


    c = Curl::Easy.new("https://api.clarifai.com/v1/tag/") do |curl|
      curl.headers['Authorization'] = 'Bearer p6W95YdN4xXHRm2Wt7QCKipuPHEnhf'
    end

    c.multipart_form_post = true

    #Curl::PostField.file('encoded_data', 'public/uploads/photo/file/1/3.png'))


    puts photo.file.url
    puts 'oi'
    puts photo

    c.http_post(Curl::PostField.content('model', 'weddings-v1.0'),
                Curl::PostField.file('encoded_data', 'public/'+photo.file.url))

    # PARSE


    parsed_tags = JSON.parse(c.body_str)['results'][0]['result']['tag']

    puts JSON.pretty_generate(parsed_tags)

    tag_list = {}

    parsed_tags['classes'].each_with_index do |tag, i|
      tag_list[tag] = parsed_tags['probs'][i]
    end

    puts tag_list

    photo.update(tag: tag_list.keys.first)
  end

end
