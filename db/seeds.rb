# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


ProductCategory.create!(code: ProductCategory::FARMING_CATEGORY_CODE, name: 'FARMING')
ProductCategory.create!(code: ProductCategory::FISHING_CATEGORY_CODE, name: 'FISHING')
ProductCategory.create!(code: ProductCategory::CATERING_CATEGORY_CODE, name: 'CATERING')
