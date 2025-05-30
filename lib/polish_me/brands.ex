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
  def subscribe_all() do
    Phoenix.PubSub.subscribe(PolishMe.PubSub, all_topic())
  end

  def subscribe_brand(id) do
    Phoenix.PubSub.subscribe(PolishMe.PubSub, brand_topic(id))
  end

  defp broadcast(message) do
    Phoenix.PubSub.broadcast(PolishMe.PubSub, all_topic(), message)
  end

  defp broadcast_brand(id, message) do
    Phoenix.PubSub.broadcast(PolishMe.PubSub, brand_topic(id), message)
  end

  defp all_topic, do: "brands"
  defp brand_topic(id), do: "brand:#{id}"

  @doc """
  Returns the list of brands.

  ## Examples

      iex> list_brands()
      [%Brand{}, ...]

  """
  def list_brands() do
    Brand |> order_by(:name) |> Repo.all()
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
    query |> where([b], ilike(b.name, ^"%#{q}%") or ilike(b.description, ^"%#{q}%"))
  end

  defp sort(query, "name_desc"), do: query |> order_by(desc: :name)
  defp sort(query, _name_asc), do: query |> order_by(asc: :name)

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
    {brand, count} =
      Brand
      |> join(:left, [b], p in assoc(b, :polishes))
      |> group_by([b, p], [b.id, p.brand_id])
      |> select([b, p], {b, count(p.brand_id)})
      |> Repo.get_by!(slug: slug)

    Map.put(brand, :polish_count, count)
  end

  @doc """
  Gets a single brand.

  Returns error tuple if the Brand does not exist.

  ## Examples

      iex> get_brand!("brand-slug")
      %Brand{}

      iex> get_brand!("no-such-slug")
      ** {:error, :not_found}

  """
  def get_brand(slug) do
    case Repo.get_by(Brand, slug: slug) do
      nil -> {:error, :not_found}
      brand -> {:ok, brand}
    end
  end

  @doc """
  Gets a single brand by its id.

    Raises `Ecto.NoResultsError` if the Brand does not exist.

  ## Examples

      iex> get_brand!(123)
      %Brand{}

      iex> get_brand!(456)
      ** (Ecto.NoResultsError)

  """
  def get_brand_by_id!(id) do
    Brand |> Repo.get!(id)
  end

  @doc """
  Creates a brand.

  ## Examples

      iex> create_brand(%{field: value})
      {:ok, %Brand{}}

      iex> create_brand(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_brand(attrs) do
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
      broadcast_brand(brand.id, {:updated, brand})
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
