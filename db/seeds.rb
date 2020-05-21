# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ProductCategory.delete_all
DeliveryOption.delete_all
Product.delete_all
Role.delete_all


ProductCategory.create!(code: ProductCategory::FARMING_CATEGORY_CODE, name: 'Farming')
ProductCategory.create!(code: ProductCategory::FISHING_CATEGORY_CODE, name: 'Fishing')
ProductCategory.create!(code: ProductCategory::CATERING_CATEGORY_CODE, name: 'Catering')

DeliveryOption.create!(code: DeliveryOption::CUSTOMER_PLACE_OPTION_CODE, option: "Customer's place")
DeliveryOption.create!(code: DeliveryOption::SHOP_OWNER_PLACE_OPTION_CODE, option: "My place")
DeliveryOption.create!(code: DeliveryOption::PARCEL_PICKUP_POINT_OPTION_CODE, option: "Parcel pick-up point")
DeliveryOption.create!(code: DeliveryOption::MARKET_PLACE_OPTION_CODE, option: "Marketplace")

Product.create!(reference: 'poyo_ref', name: 'pôyô', product_category_id: ProductCategory::FARMING_CATEGORY_CODE)
Product.create!(reference: 'igname_ref', name: 'igname', product_category_id: ProductCategory::FARMING_CATEGORY_CODE)
Product.create!(reference: 'banana_ref', name: 'banana', product_category_id: ProductCategory::FARMING_CATEGORY_CODE)
Product.create!(reference: 'pork_sausage_ref', name: 'pork sausage', product_category_id: ProductCategory::CATERING_CATEGORY_CODE)
Product.create!(reference: 'beef_sausage_ref', name: 'beef sausage', product_category_id: ProductCategory::CATERING_CATEGORY_CODE)

Role.create!(code: Role::ADMIN_ROLE_CODE, name: 'ADMIN')
Role.create!(code: Role::PARTNER_ROLE_CODE, name: 'PARTNER')
Role.create!(code: Role::CONSUMER_ROLE_CODE, name: 'CONSUMER')

Country.create!(code: '971', name: "Guadeloupe")
City.create!(postcode: "97100", name: "Basse-Terre", country_code: "971")
City.create!(postcode: "97139", name: "Les Abymes", country_code: "971")
City.create!(postcode: "97121", name: "Anse-Bertrand", country_code: "971")
City.create!(postcode: "97122", name: "Baie-Mahault", country_code: "971")
