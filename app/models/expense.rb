class Expense < ApplicationRecord
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'
  belongs_to :paid_by, class_name: 'User', foreign_key: 'paid_by_id'
  has_many :user_expenses, dependent: :destroy
  accepts_nested_attributes_for :user_expenses, allow_destroy: true
end
