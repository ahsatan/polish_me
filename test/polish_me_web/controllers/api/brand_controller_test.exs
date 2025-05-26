defmodule PolishMeWeb.API.BrandControllerTest do
  use PolishMeWeb.ConnCase

  import PolishMe.BrandsFixtures

  test "GET /api/brands", %{conn: conn} do
    brand = brand_fixture()

    conn = get(conn, ~p"/api/brands")

    assert %{"brands" => [b]} = json_response(conn, 200)
    assert b["name"] == brand.name
  end
end
