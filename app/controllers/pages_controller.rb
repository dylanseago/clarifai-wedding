class PagesController < ApplicationController
  def home
    photo = Photo.create(url: '/test/folder/.com', tag: "test")
    @photos = []
    @photos << photo
  end

  def new
  end

  def result
  end
end
