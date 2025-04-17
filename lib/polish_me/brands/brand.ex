defmodule PolishMe.Brands.Brand do
  use Ecto.Schema
  import Ecto.Changeset

  schema "brands" do
    field :name, :string
    field :slug, :string
    field :description, :string
    field :website, :string
    field :contact_email, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(brand, attrs) do
    brand
    |> cast(attrs, [:name, :slug, :description, :website, :contact_email])
    |> validate_required([:name, :slug])
    |> unique_constraint(:name)
    |> unique_constraint(:slug)
  end
end
