defmodule PolishMeWeb.API.PolishJSON do
  alias PolishMe.Polishes.Polish

  def index(%{polishes: polishes}) do
    %{polishes: Enum.map(polishes, &data/1)}
  end

  def show(%{polish: polish}) do
    %{polish: data(polish)}
  end

  defp data(%Polish{} = polish) do
    %{
      name: polish.name,
      description: polish.description,
      colors: polish.colors,
      finishes: polish.finishes,
      brand: %{name: polish.brand.name, website: polish.brand.website}
    }
  end
end
