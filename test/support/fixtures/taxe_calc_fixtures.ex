defmodule CalculateTaxes.TaxeCalcFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CalculateTaxes.TaxeCalc` context.
  """

  @doc """
  Generate a user_input.
  """
  def user_input_fixture(attrs \\ %{}) do
    {:ok, user_input} =
      attrs
      |> Enum.into(%{

      })
      |> CalculateTaxes.TaxeCalc.create_user_input()

    user_input
  end
end
