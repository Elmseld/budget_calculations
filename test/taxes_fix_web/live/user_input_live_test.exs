defmodule CalculateTaxesWeb.UserInputLiveTest do
  use CalculateTaxesWeb.ConnCase

  import Phoenix.LiveViewTest
  import CalculateTaxes.TaxeCalcFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_user_input(_) do
    user_input = user_input_fixture()
    %{user_input: user_input}
  end

  describe "Index" do
    setup [:create_user_input]

    test "lists all userinputs", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/userinputs")

      assert html =~ "Listing Userinputs"
    end

    test "saves new user_input", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/userinputs")

      assert index_live |> element("a", "New User input") |> render_click() =~
               "New User input"

      assert_patch(index_live, ~p"/userinputs/new")

      assert index_live
             |> form("#user_input-form", user_input: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#user_input-form", user_input: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/userinputs")

      html = render(index_live)
      assert html =~ "User input created successfully"
    end

    test "updates user_input in listing", %{conn: conn, user_input: user_input} do
      {:ok, index_live, _html} = live(conn, ~p"/userinputs")

      assert index_live |> element("#userinputs-#{user_input.id} a", "Edit") |> render_click() =~
               "Edit User input"

      assert_patch(index_live, ~p"/userinputs/#{user_input}/edit")

      assert index_live
             |> form("#user_input-form", user_input: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#user_input-form", user_input: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/userinputs")

      html = render(index_live)
      assert html =~ "User input updated successfully"
    end

    test "deletes user_input in listing", %{conn: conn, user_input: user_input} do
      {:ok, index_live, _html} = live(conn, ~p"/userinputs")

      assert index_live |> element("#userinputs-#{user_input.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#userinputs-#{user_input.id}")
    end
  end

  describe "Show" do
    setup [:create_user_input]

    test "displays user_input", %{conn: conn, user_input: user_input} do
      {:ok, _show_live, html} = live(conn, ~p"/userinputs/#{user_input}")

      assert html =~ "Show User input"
    end

    test "updates user_input within modal", %{conn: conn, user_input: user_input} do
      {:ok, show_live, _html} = live(conn, ~p"/userinputs/#{user_input}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit User input"

      assert_patch(show_live, ~p"/userinputs/#{user_input}/show/edit")

      assert show_live
             |> form("#user_input-form", user_input: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#user_input-form", user_input: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/userinputs/#{user_input}")

      html = render(show_live)
      assert html =~ "User input updated successfully"
    end
  end
end
