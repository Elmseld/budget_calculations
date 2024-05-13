defmodule BudgetCalculationsWeb.TaxesLive.Index do
  use BudgetCalculationsWeb, :live_view

  alias BudgetCalculations.Calculate

  @user_input %{
    "house_taxes" => 0,
    "future_house_taxes" => 0,
    "split_house_taxes" => false,
    "salary_in" => 0,
    "salary_taxes_in" => 0,
    "future_salary" => 0,
    "service_pension" => false,
    "service_pension_sum" => 0
  }

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:title, "Calculate future taxes:")
     |> assign(:form, to_form(@user_input, name: "user_input"))
     |> assign(:result, "")}
  end

  @impl true
  @spec handle_event(<<_::48, _::_*24>>, any(), map()) :: {:noreply, map()}
  def handle_event("calculate", user_number_params, socket) do
    result =
      user_number_params
      |> Calculate.to_struct()
      |> Calculate.budget_calculations()

    {:noreply,
     socket
     |> assign(:result, result)}
  end

  def handle_event("remove", _, socket) do
    {:noreply,
     socket
     |> assign(:result, "")}
  end
end
