class PhotosController < ApplicationController

  def index
  end

  def new
  end

  def create
    @photos = []
    params[:photo][:file].each { |f| @photos << Photo.create(file: f) }
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

end
