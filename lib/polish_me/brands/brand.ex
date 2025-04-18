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
    |> validate_website()
    |> validate_email()
    |> unsafe_validate_unique(:slug, PolishMe.Repo)
    |> unique_constraint(:slug)
  end

  defp validate_website(changeset) do
    changeset
    |> validate_change(:website, fn :website, website ->
      case URI.new(website) do
        {:ok, %URI{scheme: nil}} ->
          [website: "must include a scheme (e.g. https)"]

        {:ok, %URI{host: nil}} ->
          [website: "must include a host"]

        {:ok, %URI{host: host}} ->
          case :inet.gethostbyname(to_charlist(host)) do
            {:ok, _} -> []
            {:error, _} -> [website: "invalid host"]
          end

        {:error, _part} ->
          [website: "invalid format"]
      end
    end)
  end

  defp validate_email(changeset) do
    changeset
    |> validate_format(:contact_email, ~r/^[^@,;\s]+@[^@,;\s]+$/,
      message: "must have the @ sign and no spaces"
    )
    |> validate_length(:contact_email, max: 80)
  end
end
