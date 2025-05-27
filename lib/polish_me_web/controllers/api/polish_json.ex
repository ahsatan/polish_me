defmodule PolishMeWeb.API.PolishJSON do
  alias PolishMe.Polishes.Polish
  alias PolishMeWeb.API.BrandJSON

  def index(%{polishes: polishes}) do
    %{polishes: Enum.map(polishes, &data/1)}
  end

  def index_by_brand(%{brand: brand, polishes: polishes}) do
    brand_data = BrandJSON.show(%{brand: brand})

    %{brand: brand_data.brand, polishes: Enum.map(polishes, &data(&1, false))}
  end

  def show(%{polish: polish}) do
    %{polish: data(polish)}
  end

  defp data(%Polish{} = polish, display_brand \\ true) do
    %{
      name: polish.name,
      description: polish.description,
      colors: polish.colors,
      finishes: polish.finishes
    }
    |> insert_brand(polish, display_brand)
  end

  defp insert_brand(data, _polish, false), do: data

  defp insert_brand(data, polish, true) do
    data |> Map.put(:brand, %{name: polish.brand.name, website: polish.brand.website})
  end
end
