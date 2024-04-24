defmodule CalculateTaxesWeb.UserInputLive.Index do
  use CalculateTaxesWeb, :live_view

  alias CalculateTaxes.TaxeCalc

  @user_input %{
    "house_taxes" => 111_624,
    "future_house_taxes" => 0,
    "split_house_taxes" => false,
    "salary_in" => 397_200,
    "salary_taxes_in" => 84961,
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
  def handle_event("calculate", user_number_params, socket) do
    result =
      user_number_params
      |> TaxeCalc.to_struct()
      |> TaxeCalc.calculate()

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
