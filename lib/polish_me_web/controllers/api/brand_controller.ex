defmodule PolishMeWeb.API.BrandController do
  use PolishMeWeb, :controller

  alias PolishMe.Brands

  action_fallback PolishMeWeb.FallbackController

  def index(conn, _params) do
    render(conn, :index, brands: Brands.list_brands())
  end

  def show(conn, %{"slug" => slug}) do
    with {:ok, brand} <- Brands.get_brand(slug) do
      render(conn, :show, brand: brand)
    end
  end
end
