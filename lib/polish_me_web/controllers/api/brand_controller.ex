defmodule PolishMeWeb.API.BrandController do
  use PolishMeWeb, :controller

  alias PolishMe.Brands

  def index(conn, _params) do
    render(conn, :index, brands: Brands.list_brands())
  end
end
