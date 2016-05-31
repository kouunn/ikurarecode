class AddProfileToUsers < ActiveRecord::Migration
  def change
    add_column :users, :user_name, :string
    add_column :users, :icon, :string
    add_column :users, :sex, :boolean
    add_column :users, :birthday, :date
    add_column :users, :contact, :string
    add_column :users, :introduction, :text
  end
end
