# encoding: utf-8
class Product < ActiveRecord::Base
  default_scope :order => 'title'

	validates :title, :description, :image_url, :ref, :presence => true
	validates :price, :numericality => { :greater_than_or_equal_to => 0.01 }
	validates :title, :uniqueness => true, :length => { :minimum => 10, :message => "Título deve ser maior que 10 caracteres" }
	validates :image_url, :format => {
		:with		=> %r{\.(gif|jpg|png)$}i, 
		:message 	=> 'O arquivo precisa ser no format GIF, JPG ou PNG!'
	}

end
