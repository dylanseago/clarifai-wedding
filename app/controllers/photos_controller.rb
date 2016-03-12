require "net/http"
require "uri"
require 'curb'

class PhotosController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
  end

  def new
  end

  def create
    photo = Photo.create(file: params[:file])
    render :json => { response: photo }
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

end
