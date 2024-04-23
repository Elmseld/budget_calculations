defmodule CalculateTaxes.TaxeCalcTest do
  use CalculateTaxes.DataCase

  alias CalculateTaxes.TaxeCalc

  describe "userinputs" do
    alias CalculateTaxes.UserInput

    import CalculateTaxes.TaxeCalcFixtures

    @invalid_attrs %{}

    test "list_userinputs/0 returns all userinputs" do
      user_input = user_input_fixture()
      assert TaxeCalc.list_userinputs() == [user_input]
    end

    test "get_user_input!/1 returns the user_input with given id" do
      user_input = user_input_fixture()
      assert TaxeCalc.get_user_input!(user_input.id) == user_input
    end

    test "create_user_input/1 with valid data creates a user_input" do
      valid_attrs = %{}

      assert {:ok, %UserInput{} = user_input} = TaxeCalc.create_user_input(valid_attrs)
    end

    test "create_user_input/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TaxeCalc.create_user_input(@invalid_attrs)
    end

    test "update_user_input/2 with valid data updates the user_input" do
      user_input = user_input_fixture()
      update_attrs = %{}

      assert {:ok, %UserInput{} = user_input} =
               TaxeCalc.update_user_input(user_input, update_attrs)
    end

    test "update_user_input/2 with invalid data returns error changeset" do
      user_input = user_input_fixture()
      assert {:error, %Ecto.Changeset{}} = TaxeCalc.update_user_input(user_input, @invalid_attrs)
      assert user_input == TaxeCalc.get_user_input!(user_input.id)
    end

    test "delete_user_input/1 deletes the user_input" do
      user_input = user_input_fixture()
      assert {:ok, %UserInput{}} = TaxeCalc.delete_user_input(user_input)
      assert_raise Ecto.NoResultsError, fn -> TaxeCalc.get_user_input!(user_input.id) end
    end

    test "change_user_input/1 returns a user_input changeset" do
      user_input = user_input_fixture()
      assert %Ecto.Changeset{} = TaxeCalc.change_user_input(user_input)
    end
  end
end
