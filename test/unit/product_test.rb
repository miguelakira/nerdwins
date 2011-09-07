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
    assert product.errors[:ref].any?
        
  end

  test "product price must be positive" do
    product = products(:valid_tshirt)
    product.price = -1
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01",
        product.errors[:price].join('; ')

    product.price = 0
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01",
        product.errors[:price].join('; ')
    
    product.price = 1
        assert product.valid?
    end

    def new_product(image_url)
        Product.new( 
        :title          => "My Book title",
        :description    => "yyy",
        :price          => 1,
        :ref            => "0001", 
        :image_url      => image_url )
    end

    test "image url" do 
        ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg 
            http://a.b.c/x/y/z/fred.gif }
        bad = %w{ fred.doc fred.gif/more fred.gif.more }

        ok.each do |name|
            assert new_product(name).valid?, "#{name} shouldn't be invalid"
        end

        bad.each do |name|
            assert new_product(name).invalid?, "#{name} shouldn't be valid"
        end
    end

    test "product title must be unique" do
        product = Product.new( 
            :title          => products(:valid_tshirt).title,
            :description    => "yyy",
            :price          => 1,
            :ref            => "0001", 
            :image_url      => "image_url.png" )
        
        assert !product.save
        assert_equal I18n.translate('activerecord.errors.messages.taken'), product.errors[:title].join('; ')
    end

    test "product title must be at least 10 characters long" do
        product = products(:valid_tshirt)
        product.title = "not_valid"
        assert product.invalid?

        product.title = "this is a valid title"
        assert product.valid?
    end
end