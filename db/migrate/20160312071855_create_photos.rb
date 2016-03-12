class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :tag
      t.string :file

      t.timestamps null: false
    end
  end
end


