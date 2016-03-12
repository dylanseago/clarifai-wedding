class PhotosController < ApplicationController

  def index
  end

  def new
  end

  def create
    puts 'YAHOO'
    #puts params[:photo]
    #photo = Photo.new(params[:photo][:photos])

    puts params[:photo][:photos]
    uploader = PhotoUploader.new

    #uploader.store!(params[:photo][:photos])

    #if photo.save
      redirect_to pages_result_path
    #else
    #  puts 'ERROR!'
    #end
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
    params.require(:photo).permit(:file)
  end

end
