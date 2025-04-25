defmodule PolishMe.BrandsFixtures do
  alias PolishMeWeb.Helpers.TextHelpers

  @moduledoc """
  This module defines test helpers for creating
  entities via the `PolishMe.Brands` context.
  """

  @doc """
  Generate a unique brand name.
  """
  def unique_brand_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a brand.
  """
  def brand_fixture(attrs \\ %{}) do
    name = unique_brand_name()

    attrs =
      Enum.into(attrs, %{
        name: name,
        slug: TextHelpers.name_to_slug(name),
        description: "some description",
        website: "https://some.com",
        contact_email: "some@email.com"
      })

    {:ok, brand} = PolishMe.Brands.create_brand(attrs)
    brand
  end
end
