defmodule PolishMe.StashFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PolishMe.Stash` context.
  """

  @doc """
  Generate a stash_polish.
  """
  def stash_polish_fixture(scope, attrs \\ %{}) do
    polish = PolishMe.PolishesFixtures.polish_fixture()

    attrs =
      Enum.into(attrs, %{
        fill_percent: 42,
        purchase_date: ~D[2025-05-02],
        purchase_price: 42,
        status: :in_stash,
        swatched: true,
        thoughts: "some thoughts",
        polish_id: polish.id
      })

    {:ok, stash_polish} = PolishMe.Stash.create_stash_polish(scope, attrs)
    stash_polish
  end
end
