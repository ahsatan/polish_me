defmodule PolishMeWeb.API.StashControllerTest do
  use PolishMeWeb.ConnCase

  import PolishMe.StashFixtures

  describe "GET /api/stash as User" do
    setup [:register_and_log_in_user]

    test "returns the user's stash including nested polish and brand information", %{
      conn: conn,
      scope: scope
    } do
      stash_polish = stash_polish_fixture(scope)

      conn = get(conn, ~p"/api/stash")

      assert %{"stash_polishes" => [sp]} = json_response(conn, 200)
      assert sp["status"] == Atom.to_string(stash_polish.status)
      assert sp["purchase_price"] == "$0.42"
      assert sp["polish"]["name"] == stash_polish.polish.name
      assert sp["polish"]["brand"]["name"] == stash_polish.polish.brand.name
    end
  end

  test "GET /api/stash does not allow access to non-users", %{conn: conn} do
    conn = get(conn, ~p"/api/stash")

    assert html_response(conn, 302) =~ "redirected"
  end
end
