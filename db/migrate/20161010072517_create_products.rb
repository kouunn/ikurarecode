class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name_cn
      t.string :name_jp
      t.text :introduction
      t.date :release_time

      t.timestamps null: false
    end
  end
end
