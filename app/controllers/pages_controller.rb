class PagesController < ApplicationController
  def home
    @photo = Photo.new
  end
end
