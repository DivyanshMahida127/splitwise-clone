class ExpensesController < ApplicationController
  def create
    @expense = Expense.new(expense_params.merge(created_by_id: current_user.id))
    @saved = @expense.save
    if @saved
      redirect_to root_path, notice: 'Expense is saved successfully!'
    else
      redirect_to root_path, notice: 'Expense is not saved! Please try again!'
    end
  end

  private
  def expense_params
    params.require(:expense).permit(:title, :description, :date, :amount, :paid_by_id, user_expenses_attributes: [:id, :user_id, :amount])
  end
end

