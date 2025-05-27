defmodule PolishMeWeb.API.BrandJSON do
  alias PolishMe.Brands.Brand

  def index(%{brands: brands}) do
    %{brands: Enum.map(brands, &data/1)}
  end

  def show(%{brand: brand}) do
    %{brand: data(brand)}
  end

  defp data(%Brand{} = brand) do
    %{
      name: brand.name,
      description: brand.description,
      website: brand.website,
      contact_email: brand.contact_email
    }
  end
end
