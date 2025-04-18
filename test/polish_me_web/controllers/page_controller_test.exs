defmodule PolishMeWeb.PageControllerTest do
  use PolishMeWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    response = html_response(conn, 200)

    assert response =~ "Welcome to Polish.me!"
    assert response =~ "Log In or Register"
    assert response =~ "Log in to browse!"
    refute response =~ "Brands"
  end

  describe "With User" do
    setup [:register_and_log_in_user]

    test "GET /", %{conn: conn} do
      conn = get(conn, ~p"/")
      response = html_response(conn, 200)

      assert response =~ "Welcome to Polish.me!"
      assert response =~ "My Stash"
      assert response =~ "Brands"
      refute response =~ "Log in to browse!"
    end
  end
end
