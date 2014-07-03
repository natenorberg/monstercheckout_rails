json.array!(@equipment) do |equipment|
  json.extract! equipment, :id, :name, :brand, :quantity, :condition
  json.url equipment_url(equipment, format: :json)
end
