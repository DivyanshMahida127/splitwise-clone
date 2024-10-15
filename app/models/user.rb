class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :created_expenses, class_name: 'Expense', foreign_key: 'created_by_id', dependent: :destroy
  has_many :paid_expenses, class_name: 'Expense', foreign_key: 'paid_by_id', dependent: :destroy
  has_many :payments_as_payer, class_name: 'Payment', foreign_key: 'payer_id', dependent: :destroy
  has_many :payments_as_payee, class_name: 'Payment', foreign_key: 'payee_id', dependent: :destroy
  has_many :user_expenses, dependent: :destroy
  has_many :expenses, through: :user_expenses

  def calculating_dues
    paid_expenses_id = self.paid_expenses.pluck(:id)
    friends_dues = User.joins(user_expenses: :expense)
      .where(user_expenses: { expense_id: paid_expenses_id })
      .where.not(id: self.id)
      .group("users.id")
      .having("COALESCE(SUM(user_expenses.amount), 0) > 0")
      .select("users.id AS friend_id, users.name AS friend_name, COALESCE(SUM(user_expenses.amount), 0) AS total_due")
    
    my_dues = Expense.joins(user_expenses: :user)
      .joins("INNER JOIN users AS payer ON payer.id = expenses.paid_by_id")
      .where(user_expenses: { user_id: self.id })
      .where.not(paid_by_id: self.id)
      .group("payer.id, payer.name")
      .having("COALESCE(SUM(user_expenses.amount), 0) > 0")
      .select("payer.id AS owed_friend_id, payer.name AS owed_friend_name, COALESCE(SUM(user_expenses.amount), 0) AS my_total_due") 
    
    friends_dues_hash = friends_dues.each_with_object({}) do |due, hash|
      hash[due.friend_id] = { name: due.friend_name, total_due: due.total_due }
    end
    
    my_dues_hash = my_dues.each_with_object({}) do |due, hash|
      hash[due.owed_friend_id] = { name: due.owed_friend_name, my_total_due: due.my_total_due }
    end

    all_friend_ids = (friends_dues_hash.keys + my_dues_hash.keys).uniq
    total_you_owe_array = []
    total_you_are_owed_array = []
    total_you_owe = 0.0
    total_you_are_owed = 0.0

    all_friend_ids.each do |friend_id|
      friend_data = friends_dues_hash[friend_id] || { name: nil, total_due: 0 }
      my_total_due = my_dues_hash.dig(friend_id, :my_total_due) || 0
      friend_name = friend_data[:name] || my_dues_hash.dig(friend_id, :name)
      net_due = friend_data[:total_due] - my_total_due

      if net_due < 0
        total_you_owe += -net_due
        total_you_owe_array << {
          friend_id: friend_id,
          friend_name: friend_name,
          total_due: friend_data[:total_due],
          my_total_due: my_total_due,
          net_due: net_due
        }
      else
        total_you_are_owed += net_due
        total_you_are_owed_array << {
          friend_id: friend_id,
          friend_name: friend_name,
          total_due: friend_data[:total_due],
          my_total_due: my_total_due,
          net_due: net_due
        }
      end
    end
    { total_you_owe_array: total_you_owe_array, total_you_are_owed_array: total_you_are_owed_array, total_you_owe: total_you_owe, total_you_are_owed: total_you_are_owed }
  end
end
