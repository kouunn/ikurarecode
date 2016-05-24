json.array!(@keywords) do |keyword|
  json.extract! keyword, :id, :name, :count, :user_id
  json.url keyword_url(keyword, format: :json)
end
