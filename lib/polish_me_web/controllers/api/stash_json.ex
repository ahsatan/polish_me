defmodule PolishMeWeb.API.StashJSON do
  alias PolishMe.Stash.StashPolish

  alias PolishMeWeb.API.PolishJSON

  def index(%{stash_polishes: stash_polishes}) do
    %{stash_polishes: Enum.map(stash_polishes, &data/1)}
  end

  defp data(%StashPolish{} = stash_polish) do
    polish_data = PolishJSON.show(%{polish: stash_polish.polish})

    %{
      status: stash_polish.status,
      thoughts: stash_polish.thoughts,
      fill_percent: stash_polish.fill_percent,
      purchase_price: Money.to_string(stash_polish.purchase_price),
      purchase_date: stash_polish.purchase_date,
      swatched: stash_polish.swatched,
      polish: polish_data.polish
    }
  end
end
