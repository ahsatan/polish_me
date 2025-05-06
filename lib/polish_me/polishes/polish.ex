defmodule PolishMe.Polishes.Polish do
  use Ecto.Schema
  import Ecto.Changeset

  schema "polishes" do
    field :name, :string
    field :slug, :string
    field :description, :string
    field :topper, :boolean, default: false

    field :colors, {:array, Ecto.Enum},
      values: [
        :red,
        :orange,
        :yellow,
        :green,
        :blue,
        :purple,
        :pink,
        :brown,
        :white,
        :nude,
        :gray,
        :black,
        :gold,
        :silver,
        :rainbow
      ]

    field :finishes, {:array, Ecto.Enum},
      values: [
        :blacklight,
        :crelly,
        :creme,
        :duochrome,
        :flake,
        :foil,
        :gitd,
        :glitter,
        :holo,
        :jelly,
        :linear_holo,
        :magnetic,
        :metallic,
        :multichrome,
        :reflective,
        :shimmer,
        :solar,
        :thermal
      ]

    field :brand_id, :integer, writable: :insert
    belongs_to :brand, PolishMe.Brands.Brand, define_field: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(polish, attrs) do
    polish
    |> cast(attrs, [:name, :slug, :description, :colors, :finishes, :topper, :brand_id])
    |> validate_required([:name, :slug, :topper, :brand_id])
    |> validate_name()
    |> validate_slug()
    |> validate_description()
    |> unsafe_validate_unique([:name, :brand_id], PolishMe.Repo)
    |> unsafe_validate_unique([:slug, :brand_id], PolishMe.Repo)
    |> unique_constraint([:name, :brand_id])
    |> unique_constraint([:slug, :brand_id])
  end

  defp validate_name(changeset) do
    changeset
    |> validate_length(:name, max: 60)
    |> update_change(:name, &String.trim/1)
  end

  defp validate_slug(changeset) do
    changeset
    |> validate_format(:slug, ~r/^[[:alnum:]-]+$/,
      message: "must use only letters, numbers, and dash"
    )
    |> validate_length(:slug, max: 60)
  end

  defp validate_description(changeset) do
    changeset
    |> validate_length(:description, max: 1024)
    |> update_change(:description, &if(&1, do: String.trim(&1), else: &1))
  end
end
