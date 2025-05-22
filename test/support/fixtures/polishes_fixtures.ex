defmodule PolishMe.PolishesFixtures do
  alias PolishMeWeb.Helpers.TextHelpers

  @moduledoc """
  This module defines test helpers for creating
  entities via the `PolishMe.Polishes` context.
  """

  @doc """
  Generate a unique polish name.
  """
  def unique_polish_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a polish.
  """
  def polish_fixture(attrs \\ %{})

  def polish_fixture(%{brand_id: brand_id} = attrs) do
    name = unique_polish_name()

    attrs =
      Enum.into(attrs, %{
        name: name,
        slug: TextHelpers.name_to_slug(name),
        description: "some description",
        topper: false,
        colors: [:red, :gold],
        finishes: [:magnetic, :shimmer],
        brand_id: brand_id
      })

    {:ok, polish} = PolishMe.Polishes.create_polish(attrs)
    polish
  end

  def polish_fixture(attrs) do
    brand = PolishMe.BrandsFixtures.brand_fixture()

    polish_fixture(Map.put(attrs, :brand_id, brand.id))
  end
end
