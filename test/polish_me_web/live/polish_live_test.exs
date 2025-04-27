defmodule PolishMeWeb.PolishLiveTest do
  use PolishMeWeb.ConnCase

  import Phoenix.LiveViewTest
  import PolishMe.PolishesFixtures
  import PolishMe.BrandsFixtures

  @create_attrs %{
    name: "some name",
    description: "some description",
    colors: [:red, :gold],
    finishes: [:crelly, :flake],
    topper: true
  }

  @update_attrs %{
    name: "update name",
    description: "update description",
    colors: [:yellow],
    finishes: [:flake, :shimmer],
    topper: false
  }

  @invalid_attrs %{name: nil, description: nil, colors: [], finishes: []}

  defp create_polish(_context) do
    polish = polish_fixture()

    %{polish: polish}
  end

  describe "Index as User" do
    setup [:register_and_log_in_user, :create_polish]

    test "lists all polishes", %{conn: conn, polish: polish} do
      {:ok, _index_live, html} = live(conn, ~p"/polishes")

      assert html =~ "Polishes"
      assert html =~ polish.name
    end

    test "lists all brand's polishes", %{conn: conn, polish: polish} do
      other_polish = polish_fixture()

      {:ok, _index_live, html} = live(conn, ~p"/polishes/#{polish.brand.slug}")

      refute html =~ "Brand: A-Z"
      assert html =~ "#{polish.brand.name} Polishes"
      assert html =~ polish.name
      refute html =~ other_polish.name
    end

    test "loads without admin links", %{conn: conn, polish: polish} do
      {:ok, index_live, _html} = live(conn, ~p"/polishes")

      refute has_element?(index_live, ".btn", "New Polish")
      refute has_element?(index_live, "#edit-polish-#{polish.brand.slug}--#{polish.slug}")
    end

    test "filters polishes on multiple values", %{conn: conn, polish: polish} do
      other_polish = polish_fixture(%{name: "First name", colors: [:yellow, :black]})
      another_polish = polish_fixture(%{name: "Second name", colors: [:yellow]})

      {:ok, index_live, _html} = live(conn, ~p"/polishes")

      html =
        index_live
        |> form("#filter-form", %{colors: [:yellow], sort: "name_desc"})
        |> render_change()

      assert html =~ "Brand: A-Z"
      refute html =~ polish.name
      assert html =~ ~r/#{another_polish.name}.*#{other_polish.name}/s
    end
  end

  describe "Index as Admin" do
    setup [:register_and_log_in_admin, :create_polish]

    test "saves new polish", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/polishes")

      brand = brand_fixture()
      create_attrs = @create_attrs |> Map.put(:brand_id, brand.id)

      assert {:ok, form_live, html} =
               index_live
               |> element(".btn", "New Polish")
               |> render_click()
               |> follow_redirect(conn, ~p"/polishes/new")

      assert html =~ "New Polish"

      assert form_live
             |> form("#polish-form", polish: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, _index_live, html} =
               form_live
               |> form("#polish-form", polish: create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/polishes")

      assert html =~ "Polish #{create_attrs.name} created successfully"
    end

    test "updates polish in listing", %{conn: conn, polish: polish} do
      {:ok, index_live, _html} = live(conn, ~p"/polishes")

      assert {:ok, form_live, html} =
               index_live
               |> element("#edit-polish-#{polish.brand.slug}--#{polish.slug}")
               |> render_click()
               |> follow_redirect(conn, ~p"/polishes/#{polish.brand.slug}/#{polish.slug}/edit")

      assert html =~ "Edit Polish"

      assert form_live
             |> form("#polish-form", polish: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, _index_live, html} =
               form_live
               |> form("#polish-form", polish: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/polishes")

      assert html =~ "Polish #{@update_attrs.name} updated successfully"
    end
  end

  describe "Show as User" do
    setup [:register_and_log_in_user, :create_polish]

    test "displays polish", %{conn: conn, polish: polish} do
      {:ok, _show_live, html} = live(conn, ~p"/polishes/#{polish.brand.slug}/#{polish.slug}")

      assert html =~ polish.name
      assert html =~ polish.description
    end

    test "loads without admin link", %{conn: conn, polish: polish} do
      {:ok, show_live, _html} = live(conn, ~p"/polishes/#{polish.brand.slug}/#{polish.slug}")

      refute has_element?(show_live, ".btn", "Edit")
    end
  end

  describe "Show as Admin" do
    setup [:register_and_log_in_admin, :create_polish]

    test "displays polish", %{conn: conn, polish: polish} do
      {:ok, _show_live, html} = live(conn, ~p"/polishes/#{polish.brand.slug}/#{polish.slug}")

      assert html =~ polish.slug
    end

    test "updates polish and returns to show", %{conn: conn, polish: polish} do
      {:ok, show_live, _html} = live(conn, ~p"/polishes/#{polish.brand.slug}/#{polish.slug}")

      assert {:ok, form_live, html} =
               show_live
               |> element(".btn", "Edit")
               |> render_click()
               |> follow_redirect(
                 conn,
                 ~p"/polishes/#{polish.brand.slug}/#{polish.slug}/edit?return_to=show"
               )

      assert html =~ "Edit Polish"

      assert form_live
             |> form("#polish-form", polish: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, _show_live, html} =
               form_live
               |> form("#polish-form", polish: @update_attrs)
               |> render_submit()
               |> follow_redirect(
                 conn,
                 ~p"/polishes/#{polish.brand.slug}/update-name"
               )

      assert html =~ "Polish #{@update_attrs.name} updated successfully"
    end
  end

  describe "Form as User" do
    setup [:register_and_log_in_user, :create_polish]

    test "redirects when attempting to create new polish", %{conn: conn} do
      assert {:error, {:redirect, %{to: "/"}}} = live(conn, ~p"/polishes/new")
    end

    test "redirects when attempting to edit polish", %{conn: conn, polish: polish} do
      assert {:error, {:redirect, %{to: "/"}}} =
               live(conn, ~p"/polishes/#{polish.brand.slug}/#{polish.slug}/edit")
    end
  end

  describe "Form as Admin" do
    setup [:register_and_log_in_admin, :create_polish]

    test "displays live slug recommedation as placeholder", %{conn: conn} do
      {:ok, form_live, _html} = live(conn, ~p"/polishes/new")

      attrs = %{name: " Someone's N;=;me-- &Co"}

      assert form_live |> element("#slug-input") |> render() =~ "disabled"

      html = form_live |> form("#polish-form", polish: attrs) |> render_change()

      assert html =~ "value=\"someones-n-me-n-co\""
    end

    test "brand is disabled for existing polish", %{conn: conn, polish: polish} do
      {:ok, form_live, _html} = live(conn, ~p"/polishes/#{polish.brand.slug}/#{polish.slug}/edit")

      assert form_live |> element("#brand-input") |> render() =~ "disabled"
    end

    test "brand is disabled when creating a polish by brand", %{conn: conn, polish: polish} do
      {:ok, form_live, _html} = live(conn, ~p"/polishes/#{polish.brand.slug}/new")

      assert form_live |> element("#brand-input") |> render() =~ "disabled"
    end
  end
end
