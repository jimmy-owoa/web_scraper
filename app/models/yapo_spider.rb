class YapoSpider < Kimurai::Base
  @name = "yapo_spider"
  @engine = :mechanize
  @config = { before_request: { delay: 1..2 } }

  def self.process(url)
    @start_urls = [url]
    self.crawl!
  end

  def parse(response, url:, data: {})
    response.xpath("//tr[@class='ad listing_thumbs']").each do |product|
      item = {}
      item[:title] = product.css("a.title")&.text&.squish.encode("iso-8859-1").force_encoding("utf-8")
      item[:category] = product.css("span.category")&.text&.squish.encode("iso-8859-1").force_encoding("utf-8")
      item[:region] = product.css("span.region")&.text&.squish.encode("iso-8859-1").force_encoding("utf-8")
      item[:commune] = product.css("span.commune")&.text&.squish.encode("iso-8859-1").force_encoding("utf-8")
      item[:price] = product.css("span.convertedPrice")&.text.present? ? product.css("span.convertedPrice")&.text&.squish&.delete("^0-9").to_i : product.css("span.price")&.text&.squish&.delete("^0-9").to_i
      Product.where(item).first_or_create if item[:price] > 0
    end
  end
end
