defmodule PolishMeWeb.StashPolishLiveTest do
  use PolishMeWeb.ConnCase

  import Phoenix.LiveViewTest
  import PolishMe.PolishesFixtures
  import PolishMe.StashFixtures

  @create_attrs %{
    status: :destash,
    thoughts: "some thoughts",
    fill_percent: 42,
    purchase_price: 842,
    purchase_date: "2025-05-04",
    swatched: true
  }
  @update_attrs %{
    status: :panned,
    thoughts: "update thoughts",
    fill_percent: 43,
    purchase_price: 843,
    purchase_date: "2025-05-05",
    swatched: false
  }
  @invalid_attrs %{
    status: nil,
    thoughts: nil,
    fill_percent: -1,
    purchase_price: nil,
    purchase_date: nil,
    swatched: false
  }

  setup :register_and_log_in_user

  defp create_stash_polish(%{scope: scope}) do
    stash_polish = stash_polish_fixture(scope)

    %{stash_polish: stash_polish}
  end

  describe "Index" do
    setup [:create_stash_polish]

    test "lists all stash polishes", %{conn: conn, stash_polish: stash_polish} do
      {:ok, _index_live, html} = live(conn, ~p"/stash/polishes")

      assert html =~ "My Polish Stash"
      assert html =~ stash_polish.polish.name
    end

    test "filters stash polishes on multiple values", %{
      conn: conn,
      scope: scope,
      stash_polish: stash_polish
    } do
      other_polish = polish_fixture(%{name: "First name", colors: [:yellow, :black]})
      another_polish = polish_fixture(%{name: "Second name", colors: [:yellow]})
      stash_polish_fixture(scope, %{polish_id: other_polish.id})
      stash_polish_fixture(scope, %{polish_id: another_polish.id})

      {:ok, index_live, _html} = live(conn, ~p"/stash/polishes")

      html =
        index_live
        |> form("#filter-form", %{colors: [:yellow], sort: "name_desc"})
        |> render_change()

      refute html =~ stash_polish.polish.name
      assert html =~ ~r/#{another_polish.name}.*#{other_polish.name}/s
    end

    test "updates stash polish in listing", %{conn: conn, stash_polish: stash_polish} do
      {:ok, index_live, _html} = live(conn, ~p"/stash/polishes")

      assert {:ok, form_live, _html} =
               index_live
               |> element(
                 "#edit-stash-polish-#{stash_polish.polish.brand.slug}--#{stash_polish.polish.slug}"
               )
               |> render_click()
               |> follow_redirect(
                 conn,
                 ~p"/stash/polishes/#{stash_polish.polish.brand.slug}/#{stash_polish.polish.slug}/edit"
               )

      assert render(form_live) =~ "Edit My #{stash_polish.polish.name}"

      assert form_live
             |> form("#stash-polish-form", stash_polish: @invalid_attrs)
             |> render_change() =~ "must be greater than or equal to 0"

      assert {:ok, _index_live, html} =
               form_live
               |> form("#stash-polish-form", stash_polish: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/stash/polishes")

      assert html =~ "Stash #{stash_polish.polish.name} updated successfully"
      assert html =~ "Panned"
    end

    test "deletes stash polish in listing", %{conn: conn, stash_polish: stash_polish} do
      {:ok, index_live, _html} = live(conn, ~p"/stash/polishes")

      assert index_live
             |> element(
               "#delete-stash-polish-#{stash_polish.polish.brand.slug}--#{stash_polish.polish.slug}"
             )
             |> render_click()

      refute has_element?(index_live, "#stash-polishes-#{stash_polish.id}")
    end
  end

  describe "Show" do
    setup [:create_stash_polish]

    test "displays stash polish", %{conn: conn, stash_polish: stash_polish} do
      {:ok, _show_live, html} =
        live(
          conn,
          ~p"/stash/polishes/#{stash_polish.polish.brand.slug}/#{stash_polish.polish.slug}"
        )

      assert html =~ "My #{stash_polish.polish.name}"
      assert html =~ stash_polish.thoughts
    end

    test "updates stash polish and returns to show", %{conn: conn, stash_polish: stash_polish} do
      {:ok, show_live, _html} =
        live(
          conn,
          ~p"/stash/polishes/#{stash_polish.polish.brand.slug}/#{stash_polish.polish.slug}"
        )

      assert {:ok, form_live, _} =
               show_live
               |> element(".btn", "Edit")
               |> render_click()
               |> follow_redirect(
                 conn,
                 ~p"/stash/polishes/#{stash_polish.polish.brand.slug}/#{stash_polish.polish.slug}/edit?return_to=show"
               )

      assert render(form_live) =~ "Edit My #{stash_polish.polish.name}"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#stash-polish-form", stash_polish: @update_attrs)
               |> render_submit()
               |> follow_redirect(
                 conn,
                 ~p"/stash/polishes/#{stash_polish.polish.brand.slug}/#{stash_polish.polish.slug}"
               )

      html = render(show_live)
      assert html =~ "Stash #{stash_polish.polish.name} updated successfully"
      assert html =~ "update thoughts"
    end
  end

  test "create from polish", %{conn: conn} do
    polish = polish_fixture()
    {:ok, index_live, _html} = live(conn, ~p"/polishes/#{polish.brand.slug}/#{polish.slug}")

    assert {:ok, form_live, _} =
             index_live
             |> element(".btn", "Stash it!")
             |> render_click()
             |> follow_redirect(conn, ~p"/stash/polishes/#{polish.brand.slug}/#{polish.slug}/new")

    assert render(form_live) =~ "New #{polish.name} Stash"

    assert form_live
           |> form("#stash-polish-form", stash_polish: @invalid_attrs)
           |> render_change() =~ "must be greater than or equal to 0"

    assert {:ok, _index_live, html} =
             form_live
             |> form("#stash-polish-form", stash_polish: @create_attrs)
             |> render_submit()
             |> follow_redirect(conn, ~p"/stash/polishes")

    assert html =~ "Stash #{polish.name} created successfully"
    assert html =~ "Destash"
  end
end
