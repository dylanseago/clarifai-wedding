require "net/http"
require "uri"
require 'curb'

class PhotosController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    photo = Photo.create(file: params[:file])
    get_tags(photo)
    render :json => { response: photo }
  end

  private

  def photo_params
    params.require(:photo).permit(file)
  end


  def get_tags(photo)
    c = Curl::Easy.new("https://api.clarifai.com/v1/tag/") do |curl|
      curl.headers['Authorization'] = get_api_key
    end

    c.multipart_form_post = true

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

    temp_list = tag_list.sort_by {|_key, value| value}.to_h
    photo.update(buckets: bucket_tag(tag_list), tags: temp_list.keys[0..4])
  end

  def bucket_tag(tag_list)
    puts $learn_n1.classify(tag_list)
    puts $learn_n2.classify(tag_list)
    puts $learn_n3.classify(tag_list)
    puts $learn_n4.classify(tag_list)
    puts $learn_n5.classify(tag_list)
    puts $learn_n6.classify(tag_list)
    puts $learn_n7.classify(tag_list)

    matches = []

    matches << 1 if $learn_n1.classify(tag_list)
    matches << 5 if $learn_n5.classify(tag_list)
    matches << 7 if $learn_n7.classify(tag_list)
    matches << 6 if $learn_n6.classify(tag_list)
    matches << 3 if $learn_n3.classify(tag_list)
    matches << 2 if $learn_n2.classify(tag_list)
    matches << 4 if $learn_n4.classify(tag_list)

    return matches if matches
    [0]
  end


  def get_api_key
    $API_KEY ||= false
    renew_api_key if !$API_KEY || $expires_at.past?
    $API_KEY
  end

  def renew_api_key
    $expires_at = 12.hours.from_now

    c = Curl::Easy.new("https://api.clarifai.com/v1/token")
    c.http_post(Curl::PostField.content('client_id', '61vRwXZ051pJSTuAt6RDpXd1WmpLV3nAnNOkfCJx'),
                Curl::PostField.content('client_secret','aEsfUv3P6TEF6Q6fTYMN4376kxbJyxyEH-9pY7M7'),
                Curl::PostField.content('grant_type','client_credentials'))

    $API_KEY = 'Bearer ' + JSON.parse(c.body_str)["access_token"]
  end


end
