json.array!(@products) do |product|
  json.extract! product, :id, :name_cn, :name_jp, :introduction, :release_time
  json.url product_url(product, format: :json)
end
