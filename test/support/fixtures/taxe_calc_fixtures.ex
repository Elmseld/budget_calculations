defmodule BudgetCalculations.CalculateFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BudgetCalculations.Calculate` context.
  """

  @doc """
  Generate a user_input.
  """
  def user_input_fixture(attrs \\ %{}) do
    {:ok, user_input} =
      attrs
      |> Enum.into(%{})
      |> BudgetCalculations.Calculate.create_user_input()

    user_input
  end
end
