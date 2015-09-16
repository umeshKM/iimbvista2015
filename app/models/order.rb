class Order < ActiveRecord::Base

	attr_accessible :order_id, :total_amount, :created_at, :updated_at

	belongs_to :user
	has_many :order_items
end