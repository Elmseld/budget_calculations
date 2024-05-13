defmodule BudgetCalculations.UserInput do
  defstruct house_taxes: 0,
            future_house_taxes: 0,
            split_house_taxes: false,
            salary_in: 0,
            salary_taxes_in: 0,
            future_salary: 0,
            service_pension: false,
            service_pension_sum: 0,
            living_amount: 0,
            start_amount: 0,
            expected_interst: 0,
            save_per_month: 0,
            country: nil
end
