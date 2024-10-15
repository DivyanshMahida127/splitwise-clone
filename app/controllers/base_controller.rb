class BaseController < ApplicationController
  before_action :load_users, only: [:dashboard, :show_person]
  def dashboard
    @expense = Expense.new
    @expense.user_expenses.build 
    @dues = current_user.calculating_dues
    @expenses = current_user.paid_expenses
  end

  def show_person
    @user = User.find(person_params[:id])
    if @user
      @expenses = @user.paid_expenses
      @dues = @user.calculating_dues
    else
      redirect_to root_path, alert: "Not able to find the user! Please try again!"
      return 
    end
  end

  private
  def load_users
    @users = User.pluck(:id, :name)
    @current_user_id = current_user.id
  end

  def person_params
    params.permit(:id)
  end
end
