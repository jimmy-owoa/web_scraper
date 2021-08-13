class VehiclesSpider < Kimurai::Base
  @name = "vehicles_spider"
  @engine = :mechanize
  @config = { before_request: { delay: 2..4 } }

  def self.process(url)
    @start_urls = [url]
    self.crawl!
  end

  def parse(response, url:, data: {})
    response.xpath("//div[@class='vehicle-card-main']").each do |vehicle|
      item = {}
      item[:title] = vehicle.css("h2.title")&.text&.squish
      item[:price] = vehicle.css("span.primary-price")&.text&.squish&.delete("^0-9").to_i
      item[:stock_type] = vehicle.css("p.stock-type")&.text&.squish
      item[:miles] = vehicle.css("div.mileage")&.text&.squish&.delete("^0-9").to_i
      Vehicle.where(item).first_or_create
    end
  end
end
