class AddPortfolioToBrand < ActiveRecord::Migration
  def change
    add_column :brands, :portfolio, :string
  end
end
