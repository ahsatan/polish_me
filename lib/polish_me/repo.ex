defmodule PolishMe.Repo do
  use Ecto.Repo,
    otp_app: :polish_me,
    adapter: Ecto.Adapters.Postgres
end
