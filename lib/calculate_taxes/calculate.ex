defmodule BudgetCalculations.Calculate do
  @bool_key [:service_pension, :split_house_taxes]
  @moduledoc """
  The Calculate context.
  """
  alias BudgetCalculations.UserInput

  def to_struct(user_params) do
    struct(
      UserInput,
      Enum.map(user_params, fn {k, v} -> update_value(String.to_existing_atom(k), v) end)
    )
  end

  def budget_calculations(input) do
    house_taxes = input.house_taxes
    future_house_taxes = input.future_house_taxes
    split_house_taxes = input.split_house_taxes
    salary_in = input.salary_in
    salary_taxes_in = input.salary_taxes_in
    future_salary = input.future_salary
    service_pension = input.service_pension
    service_pension_sum = input.service_pension_sum

    country = System.get_env("COUNTRY_CODE", "se")
    country_spec = Application.get_env(:budget_calculations, :countries)[country]

    income_threshold_for_state_tax =
      country_spec.income_threshold_for_state_tax

    tax_rate = country_spec.income_taxes_rate
    service_pension_max = country_spec.service_pension_max

    yearly_salary = salary_in + future_salary

    service_pension_decution =
      service_pension?(service_pension, service_pension_sum, yearly_salary, service_pension_max)

    current_tax =
      calculate_tax(salary_in - service_pension_decution, salary_taxes_in, tax_rate)

    future_tax = calculate_tax(future_salary, 0, tax_rate)

    extra_tax =
      over_threshold?(yearly_salary, income_threshold_for_state_tax)

    tax_return =
      calculate_interest(house_taxes + future_house_taxes, split_house_taxes)

    total_tax =
      (current_tax + future_tax + extra_tax - tax_return)
      |> round()

    if total_tax >= 0 do
      "You are expected to pay a total of #{total_tax} SEK in taxes next year."
    else
      "You are expected to receive a total of #{abs(total_tax)} SEK in tax refunds next year."
    end
  end

  def calculate_independens(input) do
    fi_amount = input.living_amount * 12 * 25

    year_loop(input, fi_amount, 0)
  end

  defp year_loop(
         %{
           start_amount: start,
           expected_interst: interst,
           save_per_month: monthly_pay
         } = map,
         fi_amount,
         count
       )
       when start < fi_amount do
    new_map = %{map | start_amount: (start + monthly_pay * 12) * (1 + interst / 100)}
    year_loop(new_map, fi_amount, count + 1)
  end

  defp year_loop(_, _, count), do: count

  defp calculate_tax(income, paid_taxes, tax_rate) do
    # TODO - add a more correct tax_rate based on income
    income * tax_rate - paid_taxes
  end

  defp calculate_interest(paid_interest, split?) do
    return = paid_interest * 0.3

    case split? do
      true -> return / 2
      _ -> return
    end
  end

  defp over_threshold?(_, nil), do: 0

  defp over_threshold?(year_salary, threshold),
    do: ((year_salary - threshold) * 0.2) |> max(0)

  defp service_pension?(false, _, _, _), do: 0

  defp service_pension?(_, service_pension_sum, yearly_salary, service_pension_max) do
    # TODO - take out static values and set them as dynamic values instead

    deducteble_sum =
      (yearly_salary * 0.35)
      |> min(service_pension_max)

    min(service_pension_sum, deducteble_sum)
  end

  defp update_value(key, value) when key in @bool_key, do: {key, String.to_existing_atom(value)}
  defp update_value(key, ""), do: {key, 0}
  defp update_value(key, value), do: {key, String.to_integer(value)}

  defp to_int_or_nil(value) when is_binary(value), do: String.to_integer(value)
  defp to_int_or_nil(_), do: nil
end
