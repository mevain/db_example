 frozen_string_literal: true

require 'pg'
require 'faker'
require 'date'
Faker::Config.locale = 'ru'
SHOPS = 1000
BUYERS = 1000
PURCHASE = 1000
TRANSPS = 1000
PRODUCTS = 1000

DB = PG.connect dbname: 'saledep', user: 'postgres', password: '2468yutfyd'

500_000.times do |id|
    DB.exec "insert into shop (
        shop_name,
        shop_location
      )
        values (
          '#{DB.escape(Faker::Name.name)}',
          '#{DB.escape(Faker::Address.city)}'
        );"
end

1_000_000.times do |id|
    DB.exec "insert into buyer (
        buyer_name,
        buyer_birth_date,
        buyer_city
      )
        values (
          '#{DB.escape Faker::Name.name}',
          #{rand(1940..1990)},
          '#{DB.escape(Faker::Address.city)}'
        );"
end

5_500_000.times do |id|
    kn = rand(3..10)
    type = Array.new(kn) {Faker::Lorem.word}
    eaten = Array.new(kn)
    eaten.each {|i| i = (rand(100) % 3 == 0 ? 'food' : 'object')}
    pr_type = Hash[type.zip(eaten)]

    DB.exec "insert into product (
        product_name,
        product_type,
        product_price,
        shop_id
      )
        values (
          '#{DB.escape Faker::Name.first_name}',
          '#{DB.escape pr_type.to_json}',
          '#{rand(1000..10000)}',
          '#{rand(1..SHOPS)}'
        );"
end

500_000.times do |id|
    DB.exec "insert into purchase (
            product_amount,
            product_price,
            delivery_date,
            product_id
          )
            values (
                #{rand(1..100)},
                #{rand(1..10000)},
                date '#{Faker::Date.backward(days:1000)}',
                '#{rand(1..PRODUCTS)}'
            );"
end

500_000.times do |id|
    DB.exec "insert into transportation (
            shop_id,
            buyer_id
          )
            values (
                '#{rand(1..SHOPS)}',
                '#{rand(1..BUYERS)}'
            );"
end