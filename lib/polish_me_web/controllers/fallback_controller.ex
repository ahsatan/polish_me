defmodule PolishMeWeb.FallbackController do
  use PolishMeWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(json: PolishMeWeb.ErrorJSON)
    |> render(:"404")
  end
end
