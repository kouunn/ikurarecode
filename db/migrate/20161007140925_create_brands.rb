class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands do |t|
      t.string :name_cn
      t.string :name_jp
      t.text :introduction
      t.string :image_url
      t.date :creation_time
      t.string :site_address

      t.timestamps null: false
    end
  end
end
