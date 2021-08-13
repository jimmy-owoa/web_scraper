json.extract! product, :id, :title, :price, :category, :region, :commune, :created_at, :updated_at
json.url product_url(product, format: :json)
