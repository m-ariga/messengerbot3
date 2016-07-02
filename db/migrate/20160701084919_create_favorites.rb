class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.string :artist
      t.string :musicname
      t.string :genre
      t.text :url
      t.references :user, index: true, foreign_key: true

      # t.timestamps null: false
    end
  end
end
