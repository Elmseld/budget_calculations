defmodule CalculateTaxes.TaxeCalc do
  @bool_key [:service_pension, :split_house_taxes]
  @moduledoc """
  The TaxeCalc context.
  """
  alias CalculateTaxes.UserInput

  @doc """
  Returns what the taxes balance is.

  ## Examples

      iex> calculate()
      Some sort of result

  """
  def to_struct(user_params) do
    struct(
      UserInput,
      Enum.map(user_params, fn {k, v} -> update_value(String.to_existing_atom(k), v) end)
    )
  end

  def calculate(input) do
    house_taxes = input.house_taxes
    future_house_taxes = input.future_house_taxes
    split_house_taxes = input.split_house_taxes
    salary_in = input.salary_in
    salary_taxes_in = input.salary_taxes_in
    future_salary = input.future_salary
    service_pension = input.service_pension
    service_pension_sum = input.service_pension_sum

    income_threshold_for_state_tax =
      System.get_env("INCOME_THRESHOLD_FOR_STATE_TAX") |> to_int_or_nil()

    yearly_salary = salary_in + future_salary

    service_pension_decution =
      service_pension?(service_pension, service_pension_sum, yearly_salary)

    current_tax =
      calculate_tax(salary_in - service_pension_decution, salary_taxes_in)

    future_tax = calculate_tax(future_salary, 0)

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

  defp calculate_tax(income, paid_taxes) do
    # TODO - add a more correct tax_rate based on income
    tax_rate = System.get_env("INCOME_TAXES_RATE") |> String.to_float()
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

  defp service_pension?(false, _, _), do: 0

  defp service_pension?(_, service_pension_sum, yearly_salary) do
    # TODO - take out static values and set them as dynamic values instead
    deducteble_sum =
      (yearly_salary * 0.35)
      |> min(573_000)

    min(service_pension_sum, deducteble_sum)
  end

  defp update_value(key, value) when key in @bool_key, do: {key, String.to_existing_atom(value)}
  defp update_value(key, ""), do: {key, 0}
  defp update_value(key, value), do: {key, String.to_integer(value)}

  defp to_int_or_nil(value) when is_binary(value), do: String.to_integer(value)
  defp to_int_or_nil(_), do: nil
end
