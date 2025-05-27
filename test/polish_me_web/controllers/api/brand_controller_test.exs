defmodule PolishMeWeb.API.BrandControllerTest do
  use PolishMeWeb.ConnCase

  import PolishMe.BrandsFixtures

  test "GET /api/brands", %{conn: conn} do
    brand = brand_fixture()

    conn = get(conn, ~p"/api/brands")

    assert %{"brands" => [b]} = json_response(conn, 200)
    assert b["name"] == brand.name
  end

  describe "GET /api/brands/:slug" do
    test "successfully finds existing brand", %{conn: conn} do
      brand = brand_fixture()

      conn = get(conn, ~p"/api/brands/#{brand.slug}")

      assert %{"brand" => b} = json_response(conn, 200)
      assert b["name"] == brand.name
    end

    test "returns well-formatted error message when brand does not exist", %{conn: conn} do
      conn = get(conn, ~p"/api/brands/slug")

      assert %{"errors" => %{"detail" => "Not Found"}} = json_response(conn, 404)
    end
  end
end
