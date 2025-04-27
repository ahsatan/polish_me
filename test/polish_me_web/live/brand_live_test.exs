defmodule PolishMeWeb.BrandLiveTest do
  use PolishMeWeb.ConnCase

  import Phoenix.LiveViewTest
  import PolishMe.BrandsFixtures

  @create_attrs %{
    name: "some name",
    description: "some description",
    website: "https://some.com",
    contact_email: "some@email.com"
  }

  @update_attrs %{
    name: "update name",
    description: "update description",
    website: "https://update.com",
    contact_email: "update@email.com"
  }

  @invalid_attrs %{name: nil, description: nil, website: nil, contact_email: nil}

  defp create_brand(_context) do
    brand = brand_fixture()

    %{brand: brand}
  end

  describe "Index as User" do
    setup [:register_and_log_in_user, :create_brand]

    test "lists all brands", %{conn: conn, brand: brand} do
      {:ok, _index_live, html} = live(conn, ~p"/brands")

      assert html =~ "Brands"
      assert html =~ brand.name
    end

    test "loads without admin links", %{conn: conn, brand: brand} do
      {:ok, index_live, _html} = live(conn, ~p"/brands")

      refute has_element?(index_live, ".btn", "New Brand")
      refute has_element?(index_live, "#edit-brand-#{brand.slug}")
    end

    test "filters brands on query and sort order", %{conn: conn, brand: brand} do
      {:ok, index_live, _html} = live(conn, ~p"/brands")

      matching_brand = brand_fixture(%{name: "match name"})
      other_matching_brand = brand_fixture(%{name: "zed", description: "match description"})

      html =
        index_live
        |> form("#filter-form", %{q: "match", sort: "name_desc"})
        |> render_change()

      refute html =~ brand.name
      assert html =~ ~r/#{other_matching_brand.name}.*#{matching_brand.name}/s
    end
  end

  describe "Index as Admin" do
    setup [:register_and_log_in_admin, :create_brand]

    test "saves new brand", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/brands")

      assert {:ok, form_live, html} =
               index_live
               |> element(".btn", "New Brand")
               |> render_click()
               |> follow_redirect(conn, ~p"/brands/new")

      assert html =~ "New Brand"

      assert form_live
             |> form("#brand-form", brand: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, _index_live, html} =
               form_live
               |> form("#brand-form", brand: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/brands")

      assert html =~ "Brand #{@create_attrs.name} created successfully"
    end

    test "updates brand in listing", %{conn: conn, brand: brand} do
      {:ok, index_live, _html} = live(conn, ~p"/brands")

      assert {:ok, form_live, html} =
               index_live
               |> element("#edit-brand-#{brand.slug}")
               |> render_click()
               |> follow_redirect(conn, ~p"/brands/#{brand.slug}/edit")

      assert html =~ "Edit Brand"

      assert form_live
             |> form("#brand-form", brand: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, _index_live, html} =
               form_live
               |> form("#brand-form", brand: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/brands")

      assert html =~ "Brand #{@update_attrs.name} updated successfully"
    end
  end

  describe "Show as User" do
    setup [:register_and_log_in_user, :create_brand]

    test "displays brand", %{conn: conn, brand: brand} do
      {:ok, _show_live, html} = live(conn, ~p"/brands/#{brand.slug}")

      assert html =~ brand.name
      assert html =~ brand.description
    end

    test "loads without admin link", %{conn: conn, brand: brand} do
      {:ok, show_live, _html} = live(conn, ~p"/brands/#{brand.slug}")

      refute has_element?(show_live, ".btn", "Edit")
    end
  end

  describe "Show as Admin" do
    setup [:register_and_log_in_admin, :create_brand]

    test "displays brand", %{conn: conn, brand: brand} do
      {:ok, _show_live, html} = live(conn, ~p"/brands/#{brand.slug}")

      assert html =~ brand.slug
    end

    test "updates brand and returns to show", %{conn: conn, brand: brand} do
      {:ok, show_live, _html} = live(conn, ~p"/brands/#{brand.slug}")

      assert {:ok, form_live, html} =
               show_live
               |> element(".btn", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/brands/#{brand.slug}/edit?return_to=show")

      assert html =~ "Edit Brand"

      assert form_live
             |> form("#brand-form", brand: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, _show_live, html} =
               form_live
               |> form("#brand-form", brand: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/brands/update-name")

      assert html =~ "Brand #{@update_attrs.name} updated successfully"
    end

    test "creates brand's polish and returns to show", %{conn: conn, brand: brand} do
      {:ok, show_live, _html} = live(conn, ~p"/brands/#{brand.slug}")

      assert {:ok, form_live, html} =
               show_live
               |> element(".btn", "New Polish")
               |> render_click()
               |> follow_redirect(conn, ~p"/polishes/#{brand.slug}/new")

      assert html =~ "New #{brand.name} Polish"

      attrs = %{name: "polish name"}

      assert {:ok, _show_live, html} =
               form_live
               |> form("#polish-form", polish: attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/brands/#{brand.slug}")

      assert html =~ "Polish #{attrs.name} created successfully"
    end
  end

  describe "Form as User" do
    setup [:register_and_log_in_user, :create_brand]

    test "redirects when attempting to create new brand", %{conn: conn} do
      assert {:error, {:redirect, %{to: "/"}}} = live(conn, ~p"/brands/new")
    end

    test "redirects when attempting to edit brand", %{conn: conn, brand: brand} do
      assert {:error, {:redirect, %{to: "/"}}} = live(conn, ~p"/brands/#{brand.slug}/edit")
    end
  end

  describe "Form as Admin" do
    setup [:register_and_log_in_admin]

    test "displays live slug recommendation as a disabled field", %{conn: conn} do
      {:ok, form_live, _html} = live(conn, ~p"/brands/new")

      attrs = %{name: " Someone's N;=;me-- &Co"}

      assert form_live |> element("#slug-input") |> render() =~ "disabled"

      html = form_live |> form("#brand-form", brand: attrs) |> render_change()

      assert html =~ "value=\"someones-n-me-n-co\""
    end
  end
end
