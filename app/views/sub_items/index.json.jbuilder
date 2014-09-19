json.array!(@sub_items) do |sub_item|
  json.extract! sub_item, :id, :name, :brand, :kit, :description, :is_optional
  json.url sub_item_url(sub_item, format: :json)
end
