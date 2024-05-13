defmodule BudgetCalculationsWeb.FinanciallyIndependentLive.Index do
  use BudgetCalculationsWeb, :live_view

  alias BudgetCalculations.Calculate

  @user_input %{
    "living_amount" => 0,
    "start_amount" => 0,
    "expected_interst" => 0,
    "save_per_month" => 0
  }

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:title, "Calculate for financially independens:")
     |> assign(:form, to_form(@user_input, name: "user_input"))
     |> assign(:result, "")}
  end

  @impl true
  @spec handle_event(<<_::48, _::_*24>>, any(), map()) :: {:noreply, map()}
  def handle_event("calculate", user_number_params, socket) do
    result =
      user_number_params
      |> Calculate.to_struct()
      |> Calculate.calculate_independens()

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
