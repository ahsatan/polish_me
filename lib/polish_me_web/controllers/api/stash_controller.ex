defmodule PolishMeWeb.API.StashController do
  use PolishMeWeb, :controller

  alias PolishMe.Stash

  def index(conn, _params) do
    render(conn, :index, stash_polishes: Stash.list_stash_polishes(conn.assigns.current_scope))
  end
end
