require "net/http"
require "uri"
require 'curb'

class PhotosController < ApplicationController

  def index
  end

  def new
  end

  def create
    @photos = []
    params[:photo][:file].each do |f|
      photo = Photo.new(file: f)

      get_tags("test")
      @photos << photo
    end

    render 'pages/result'
  end

  def edit
  end

  def show
  end

  def update
  end

  def destroy
  end

  private

  def photo_params
    params.require(:photo).permit(file)
  end

  def get_tags(f)
    c = Curl::Easy.new("https://api.clarifai.com/v1/tag/") do |curl|
      curl.headers['Authorization'] = 'Bearer p6W95YdN4xXHRm2Wt7QCKipuPHEnhf'
    end

    c.multipart_form_post = true

    c.http_post(
        Curl::PostField.content('model', 'weddings-v1.0'),
         Curl::PostField.file('encoded_data', 'public/uploads/photo/file/1/3.png'))

    # PARSE
    puts c.body_str
    c.body_str
  end

end
