class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :url
      t.string :tag

      t.timestamps null: false
    end
  end
end
