# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PolishMe.Repo.insert!(%PolishMe.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias PolishMe.Repo
alias PolishMe.Accounts.User

_alpha = %User{email: "alpha@test.com", is_admin: true} |> Repo.insert!()
_beta = %User{email: "beta@test.com"} |> Repo.insert!()
