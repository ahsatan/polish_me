defmodule PolishMe.BrandsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PolishMe.Brands` context.
  """

  @doc """
  Generate a unique brand name.
  """
  def unique_brand_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a unique brand slug.
  """
  def unique_brand_slug, do: "some-slug#{System.unique_integer([:positive])}"

  @doc """
  Generate a brand.
  """
  def brand_fixture(attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        name: unique_brand_name(),
        slug: unique_brand_slug(),
        description: "some description",
        website: "https://some.com",
        contact_email: "some@email.com"
      })

    {:ok, brand} = PolishMe.Brands.create_brand(attrs)
    brand
  end
end
