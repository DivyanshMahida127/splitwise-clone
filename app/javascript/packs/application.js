// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

import jQuery from 'jquery';
window.$ = jQuery
window.jQuery = jQuery

import 'bootstrap/dist/js/bootstrap'
import Choices from 'choices.js'
require("jgrowl")
Rails.start()
Turbolinks.start()
ActiveStorage.start()
$(document).on('turbolinks:load', function() {
  const $selectElement = $('#choices-multiple-remove-button');
  const $userExpensesContainer = $('#user-expenses-container');
  const $totalAmount = $('#expense_amount');

  if ($selectElement.length) {
    const choices = new Choices($selectElement[0], {
      removeItemButton: true,
    });

    let index = 0;

    const createUserExpenseFields = (userId, userName, amount) => {
      const $expenseDiv = $(`
        <div class="user-expense row mb-2">
          <div class="form-group col mb-1">
            <select name="expense[user_expenses_attributes][${index}][user_id]" class="form-control" id="expense_user_expenses_attributes_${index}_user_id">
              <option value="${userId}">${userName}</option>
            </select>
          </div>
          <div class="form-group col mb-1">
            <input type="number" name="expense[user_expenses_attributes][${index}][amount]" step="0.01" class="form-control" id="expense_user_expenses_attributes_${index}_amount" value="${amount}" ${amount ? 'readonly' : ''}>
          </div>
        </div>
      `);

      $userExpensesContainer.append($expenseDiv);
      index++;
    };

    const updateUserExpenses = () => {
      $userExpensesContainer.empty();
      index = 0;
      const selectedOptions = $selectElement[0].selectedOptions;

      const totalAmount = parseFloat($totalAmount.val()) || 0;
      const userCount = selectedOptions.length;
      if (userCount > 0) {
        const splitType = $('input[name="split_type"]:checked').val();
        if (splitType === 'equally') {
          const splitAmount = (totalAmount / userCount).toFixed(2);
          const totalSplitAmount = (splitAmount * userCount).toFixed(2);
          const remainder = (totalAmount - totalSplitAmount).toFixed(2); 
          $.each(selectedOptions, function(_, option) {
            createUserExpenseFields(option.value, option.text, splitAmount);
          });

          if (remainder > 0) {
            const firstUserAmountInput = $userExpensesContainer.find('input[type="number"]').first();
            firstUserAmountInput.val((parseFloat(firstUserAmountInput.val()) + parseFloat(remainder)).toFixed(2)); 
          }
          else if (remainder < 0) {const firstUserAmountInput = $userExpensesContainer.find('input[type="number"]').first();
            firstUserAmountInput.val((parseFloat(firstUserAmountInput.val()) + parseFloat(remainder)).toFixed(2));

          }
        } else if (splitType === 'unequally') {
          $.each(selectedOptions, function(_, option) {
            createUserExpenseFields(option.value, option.text, '');
          });
        }
      }
    };

    const validateTotalAmount = () => {
      const totalAmount = parseFloat($totalAmount.val()) || 0;
      let enteredTotal = 0;

      $userExpensesContainer.find('input[type="number"]').each(function() {
        enteredTotal += parseFloat($(this).val()) || 0;
      });

      if (enteredTotal !== totalAmount) {
        return false;
      }
      return true;
    };

    const handleRadioChange = () => {
      const selectedValue = $('input[name="split_type"]:checked').val();
      if (selectedValue) {
        updateUserExpenses();
      } else {
        $userExpensesContainer.empty();
        index = 0;
      }
    };

    $totalAmount.on('input', updateUserExpenses);
    $selectElement.on('change', updateUserExpenses);

    $('input[name="split_type"]').change(handleRadioChange);

    $('form').on('submit', function(event) {
      if ($('input[name="split_type"]:checked').val() === 'unequally') {
        if (!validateTotalAmount()) {
          event.preventDefault();
          alert('The entered amounts do not equal the total amount. Please correct the amounts.');
          setTimeout(() => {
            $('#expense-submit-button').prop('disabled', false);
          }, 1000);
        }
      }
    });
  }
});