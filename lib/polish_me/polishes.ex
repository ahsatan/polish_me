defmodule PolishMe.Polishes do
  @moduledoc """
  The Polishes context.
  """

  import Ecto.Query, warn: false

  alias PolishMe.Repo
  alias PolishMe.Brands.Brand
  alias PolishMe.Polishes.Polish

  @doc """
  Subscribes to notifications about all or specific polish changes.

  The broadcasted messages match the pattern:

    * {:created, %Polish{}}
    * {:updated, %Polish{}}

  """
  def subscribe() do
    Phoenix.PubSub.subscribe(PolishMe.PubSub, "polishes")
  end

  def subscribe(id) do
    Phoenix.PubSub.subscribe(PolishMe.PubSub, "polish:#{id}")
  end

  defp broadcast(message) do
    Phoenix.PubSub.broadcast(PolishMe.PubSub, "polishes", message)
  end

  defp broadcast(id, message) do
    Phoenix.PubSub.broadcast(PolishMe.PubSub, "polish:#{id}", message)
  end

  @doc """
  Returns the list of polishes.

  ## Examples

      iex> list_polishes()
      [%Polish{}, ...]

  """
  def list_polishes() do
    Polish
    |> Repo.all()
    |> preload_brand()
  end

  @doc """
  Gets a single polish.

  Raises `Ecto.NoResultsError` if the Polish does not exist.

  ## Examples

      iex> get_polish!("brand-slug", "polish-slug")
      %Polish{}

      iex> get_polish!("brand-slug", "no-such-slug")
      ** (Ecto.NoResultsError)

  """
  def get_polish!(brand_slug, polish_slug) do
    Polish
    |> join(:inner, [p], b in assoc(p, :brand))
    |> where([p, b], b.slug == ^brand_slug and p.slug == ^polish_slug)
    |> Repo.one!()
    |> preload_brand()
  end

  @doc """
  Creates a polish.

  ## Examples

      iex> create_polish(%{field: value})
      {:ok, %Polish{}}

      iex> create_polish(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_polish(attrs \\ %{}) do
    with {:ok, polish = %Polish{}} <-
           %Polish{}
           |> Polish.changeset(attrs)
           |> Repo.insert() do
      broadcast({:created, polish})
      {:ok, polish |> preload_brand()}
    end
  end

  @doc """
  Updates a polish.

  ## Examples

      iex> update_polish(polish, %{field: new_value})
      {:ok, %Polish{}}

      iex> update_polish(polish, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_polish(%Polish{} = polish, attrs) do
    with {:ok, polish = %Polish{}} <-
           polish
           |> Polish.changeset(attrs)
           |> Repo.update() do
      broadcast({:updated, polish})
      broadcast(polish.id, {:updated, polish})
      {:ok, polish |> preload_brand()}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking polish changes.

  ## Examples

      iex> change_polish(polish)
      %Ecto.Changeset{data: %Polish{}}

  """
  def change_polish(%Polish{} = polish, attrs \\ %{}) do
    Polish.changeset(polish, attrs)
  end

  defp preload_brand(polish) do
    polish |> Repo.preload(brand: select(Brand, [:name, :slug]))
  end

  def get_colors() do
    Polish |> Ecto.Enum.values(:colors)
  end

  def get_finishes() do
    Polish |> Ecto.Enum.values(:finishes)
  end
end
