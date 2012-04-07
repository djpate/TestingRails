require 'test_helper'

class ProductTest < ActiveSupport::TestCase

	fixtures :products

  test "product attributes must not be empty" do
  	product = Product.new
  	assert product.invalid?
  	assert product.errors[:title].any?
  	assert product.errors[:description].any?
  	assert product.errors[:price].any?
  	assert product.errors[:image_url].any?
  end

  test "product price must be positive" do
  	product = Product.new(title: "My book title",
  						  description: 'desc',
  						  image_url: 'zzz.jpg')

  	product.price = -1	
  	assert product.invalid?
  	assert_equal "must be greater than or equal to 0.01",
  		product.errors[:price].join('; ')

  	product.price = 1
  	assert product.valid?

  end

  test "image_url shoud be an image url :)" do

  	p = Product.new(title: "My book title",
  						  description: 'desc',
  						  price: 1)


	ok = %w{ fred.gif fred.jpg frend.png FRED.png }
	bad = %w{ fred.doc fred.exe  }

	ok.each do |item|
		p.image_url = item
		assert p.valid?, "#{item} should be a valid image_url"
	end

	bad.each do |item|
		p.image_url = item
		assert p.invalid?, "#{item} should not be valid image_url"
	end

  end

  test "product title is unique" do
  	product = Product.new(title: products(:ruby).title,
  						  description: 'yyy',
  						  price: 1,
  						  image_url: 'fred.gif')

  	assert !product.save

  	
  end

end
