defmodule PolishMe.PolishesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PolishMe.Polishes` context.
  """

  @doc """
  Generate a unique polish name.
  """
  def unique_polish_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a unique polish slug.
  """
  def unique_polish_slug, do: "some-slug#{System.unique_integer([:positive])}"

  @doc """
  Generate a polish.
  """
  def polish_fixture(attrs \\ %{}) do
    brand = PolishMe.BrandsFixtures.brand_fixture()

    attrs =
      Enum.into(attrs, %{
        name: unique_polish_name(),
        slug: unique_polish_slug(),
        description: "some description",
        topper: false,
        colors: [:red, :gold],
        finishes: [:magnetic, :shimmer],
        brand_id: brand.id
      })

    {:ok, polish} = PolishMe.Polishes.create_polish(attrs)
    polish
  end
end
