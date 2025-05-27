defmodule PolishMeWeb.API.PolishController do
  use PolishMeWeb, :controller

  alias PolishMe.Brands
  alias PolishMe.Polishes

  action_fallback PolishMeWeb.FallbackController

  def index(conn, _params) do
    render(conn, :index, polishes: Polishes.list_polishes())
  end

  def index_by_brand(conn, %{"brand_slug" => brand_slug}) do
    with {:ok, brand} <- Brands.get_brand(brand_slug) do
      render(
        conn,
        :index_by_brand,
        brand: brand,
        polishes: Polishes.filter_polishes(%{"brand_id" => brand.id})
      )
    end
  end

  def show(conn, %{"brand_slug" => brand_slug, "polish_slug" => polish_slug}) do
    with {:ok, polish} <- Polishes.get_polish(brand_slug, polish_slug) do
      render(conn, :show, polish: polish)
    end
  end
end
