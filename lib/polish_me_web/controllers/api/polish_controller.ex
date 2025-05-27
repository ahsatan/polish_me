defmodule PolishMeWeb.API.PolishController do
  use PolishMeWeb, :controller

  alias PolishMe.Polishes

  action_fallback PolishMeWeb.FallbackController

  def index(conn, _params) do
    render(conn, :index, polishes: Polishes.list_polishes())
  end

  def show(conn, %{"brand_slug" => brand_slug, "polish_slug" => polish_slug}) do
    with {:ok, polish} <- Polishes.get_polish(brand_slug, polish_slug) do
      render(conn, :show, polish: polish)
    end
  end
end
