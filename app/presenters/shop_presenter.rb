class ShopPresenter

  def initialize(shop)
    @shop = shop
  end

  def delivery_options
    @shop.delivery_options.each_with_object("") do |delivery_option, s|
      s << "<span class='badge badge-info'>#{delivery_option.to_option}</span> "
    end
  end

  def cities
    @shop.cities.each_with_object("") do |city, s|
      s << "<span class='badge badge-primary'>#{city.name}</span> "
    end
  end

end
