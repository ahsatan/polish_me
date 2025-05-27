defmodule PolishMeWeb.API.PolishControllerTest do
  use PolishMeWeb.ConnCase

  import PolishMe.PolishesFixtures

  test "GET /api/polishes", %{conn: conn} do
    polish = polish_fixture(%{colors: [:red, :gold], finishes: [:shimmer, :flake]})

    conn = get(conn, ~p"/api/polishes")

    assert %{"polishes" => [p]} = json_response(conn, 200)
    assert p["name"] == polish.name
    assert p["brand"]["name"] == polish.brand.name
    assert p["colors"] == ["red", "gold"]
    assert p["finishes"] == ["shimmer", "flake"]
  end

  test "GET /api/polishes/:brand_slug/:polish_slug", %{conn: conn} do
    polish = polish_fixture(%{colors: [:red, :gold], finishes: [:shimmer, :flake]})

    conn = get(conn, ~p"/api/polishes/#{polish.brand.slug}/#{polish.slug}")

    assert %{"polish" => p} = json_response(conn, 200)
    assert p["name"] == polish.name
    assert p["brand"]["name"] == polish.brand.name
    assert p["colors"] == ["red", "gold"]
    assert p["finishes"] == ["shimmer", "flake"]
  end

  test "returns well-formatted error message when polish does not exist", %{conn: conn} do
    conn = get(conn, ~p"/api/polishes/slug/slug")

    assert %{"errors" => %{"detail" => "Not Found"}} = json_response(conn, 404)
  end
end
