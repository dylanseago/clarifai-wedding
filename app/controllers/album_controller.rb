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

    return photo.bucket if photo.bucket


    c = Curl::Easy.new("https://api.clarifai.com/v1/tag/") do |curl|
      curl.headers['Authorization'] = 'Bearer p6W95YdN4xXHRm2Wt7QCKipuPHEnhf'
    end

    c.multipart_form_post = true

    #Curl::PostField.file('encoded_data', 'public/uploads/photo/file/1/3.png'))


    puts photo.file.url
    puts 'oi'
    puts photo

    c.http_post(Curl::PostField.content('model', 'weddings-v1.0'),
                Curl::PostField.content('select_classes',"bride,groom,bridesmaids,food,wedding party,reception,ceremony,vows,kiss,fashion,jewelry,rings,invitations,bedroom,flowers,bouquet,getting ready,ring bearer,table,decor"),
                Curl::PostField.file('encoded_data', 'public/'+photo.file.url))


    # PARSE

    parsed_tags = JSON.parse(c.body_str)['results'][0]['result']['tag']

    puts JSON.pretty_generate(parsed_tags)

    tag_list = {}

    parsed_tags['classes'].each_with_index do |tag, i|
      tag_list[tag] = parsed_tags['probs'][i].to_f
    end

    tag_list = tag_list.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}


    puts tag_list

    photo.update(bucket: bucket_tag(tag_list), tags: tag_list.keys)
  end

  def bucket_tag(tag_list)
    puts $learn_n1.classify(tag_list)
    puts $learn_n2.classify(tag_list)
    puts $learn_n3.classify(tag_list)
    puts $learn_n4.classify(tag_list)
    puts $learn_n5.classify(tag_list)
    puts $learn_n6.classify(tag_list)
    puts $learn_n7.classify(tag_list)

    return 1 if $learn_n1.classify(tag_list)
    return 5 if $learn_n5.classify(tag_list)
    return 7 if $learn_n7.classify(tag_list)
    return 6 if $learn_n6.classify(tag_list)
    return 3 if $learn_n3.classify(tag_list)
    return 2 if $learn_n2.classify(tag_list)
    return 4 if $learn_n4.classify(tag_list)
    0
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
