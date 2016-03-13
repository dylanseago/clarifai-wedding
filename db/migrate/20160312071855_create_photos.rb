class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer :buckets,   array: true, default: []
      t.string :tags,   array: true, default: []

      t.string :file

      t.timestamps null: false
    end
  end
end


