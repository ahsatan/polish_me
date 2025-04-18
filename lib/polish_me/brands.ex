defmodule PolishMe.Brands do
  @moduledoc """
  The Brands context.
  """

  import Ecto.Query, warn: false

  alias PolishMe.Repo
  alias PolishMe.Brands.Brand

  @doc """
  Subscribes to notifications about all or specific brand changes.

  The broadcasted messages match the pattern:

    * {:created, %Brand{}}
    * {:updated, %Brand{}}

  """
  def subscribe() do
    Phoenix.PubSub.subscribe(PolishMe.PubSub, "brands")
  end

  def subscribe(id) do
    Phoenix.PubSub.subscribe(PolishMe.PubSub, "brand:#{id}")
  end

  defp broadcast(message) do
    Phoenix.PubSub.broadcast(PolishMe.PubSub, "brands", message)
  end

  defp broadcast(id, message) do
    Phoenix.PubSub.broadcast(PolishMe.PubSub, "brand:#{id}", message)
  end

  @doc """
  Returns the list of brands.

  ## Examples

      iex> list_brands()
      [%Brand{}, ...]

  """
  def list_brands() do
    Brand |> Repo.all()
  end

  @doc """
  Filters the list of brands.

  ## Examples

      iex> filter_brands(%{"q" => "query"})
      [%Brand{}, ...]

  """
  def filter_brands(filters) do
    Brand
    |> query_search(filters["q"])
    |> sort(filters["sort"])
    |> Repo.all()
  end

  defp query_search(query, q) when q in [nil, ""], do: query

  defp query_search(query, q) do
    query
    |> where([b], ilike(b.name, ^"%#{q}%") or ilike(b.description, ^"%#{q}%"))
  end

  defp sort(query, "name_desc") do
    query |> order_by(desc: :name)
  end

  defp sort(query, _name_asc) do
    query |> order_by(:name)
  end

  @doc """
  Gets a single brand.

  Raises `Ecto.NoResultsError` if the Brand does not exist.

  ## Examples

      iex> get_brand!("brand-slug")
      %Brand{}

      iex> get_brand!("no-such-slug")
      ** (Ecto.NoResultsError)

  """
  def get_brand!(slug) do
    Brand |> Repo.get_by!(slug: slug)
  end

  @doc """
  Creates a brand.

  ## Examples

      iex> create_brand(%{field: value})
      {:ok, %Brand{}}

      iex> create_brand(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_brand(attrs \\ %{}) do
    with {:ok, brand = %Brand{}} <-
           %Brand{}
           |> Brand.changeset(attrs)
           |> Repo.insert() do
      broadcast({:created, brand})
      {:ok, brand}
    end
  end

  @doc """
  Updates a brand.

  ## Examples

      iex> update_brand(brand, %{field: new_value})
      {:ok, %Brand{}}

      iex> update_brand(brand, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_brand(%Brand{} = brand, attrs) do
    with {:ok, brand = %Brand{}} <-
           brand
           |> Brand.changeset(attrs)
           |> Repo.update() do
      broadcast({:updated, brand})
      broadcast(brand.id, {:updated, brand})
      {:ok, brand}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking brand changes.

  ## Examples

      iex> change_brand(brand)
      %Ecto.Changeset{data: %Brand{}}

  """
  def change_brand(%Brand{} = brand, attrs \\ %{}) do
    Brand.changeset(brand, attrs)
  end
end
