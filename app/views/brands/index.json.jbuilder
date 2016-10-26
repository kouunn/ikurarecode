json.array!(@brands) do |brand|
  json.extract! brand, :id, :name_cn, :name_jp, :introduction, :image_url, :creation_time, :site_address
  json.url brand_url(brand, format: :json)
end
