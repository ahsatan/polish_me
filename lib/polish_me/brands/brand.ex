defmodule PolishMe.Brands.Brand do
  use Ecto.Schema
  import Ecto.Changeset

  schema "brands" do
    field :name, :string
    field :slug, :string
    field :description, :string
    field :website, :string
    field :contact_email, :string

    has_many :polishes, PolishMe.Polishes.Polish

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(brand, attrs) do
    brand
    |> cast(attrs, [:name, :slug, :description, :website, :contact_email])
    |> validate_required([:name, :slug])
    |> validate_name()
    |> validate_slug()
    |> validate_description()
    |> validate_website()
    |> validate_email()
    |> unsafe_validate_unique(:name, PolishMe.Repo)
    |> unsafe_validate_unique(:slug, PolishMe.Repo)
    |> unique_constraint(:name)
    |> unique_constraint(:slug)
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
    |> validate_length(:website, max: 80)
  end

  defp validate_email(changeset) do
    changeset
    |> validate_format(:contact_email, ~r/^[^@,;\s]+@[^@,;\s]+$/,
      message: "must have the @ sign and no spaces"
    )
    |> validate_length(:contact_email, max: 80)
  end
end
