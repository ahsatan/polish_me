defmodule PolishMeWeb.API.BrandJSON do
  alias PolishMe.Brands.Brand

  def index(%{brands: brands}) do
    %{brands: Enum.map(brands, &to_json/1)}
  end

  defp to_json(%Brand{} = brand) do
    %{
      name: brand.name,
      description: brand.description,
      website: brand.website,
      contact_email: brand.contact_email
    }
  end
end
