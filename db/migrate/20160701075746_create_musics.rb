class CreateMusics < ActiveRecord::Migration
  def change
    create_table :musics do |t|
      t.string :artist
      t.string :musicname
      t.string :genre
      t.text :url

      t.timestamps null: false
    end
  end
end
