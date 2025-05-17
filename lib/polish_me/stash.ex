defmodule PolishMe.Stash do
  @moduledoc """
  The Stash context.
  """

  import Ecto.Query, warn: false

  alias PolishMe.Repo
  alias PolishMe.Brands.Brand
  alias PolishMe.Polishes.Polish
  alias PolishMe.Stash.StashPolish
  alias PolishMe.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any stashed polish's changes.

  The broadcasted messages match the pattern:

    * {:created, %StashPolish{}}
    * {:updated, %StashPolish{}}
    * {:deleted, %StashPolish{}}

  """
  def subscribe_all(%Scope{} = scope) do
    Phoenix.PubSub.subscribe(PolishMe.PubSub, all_topic(scope))
  end

  def subscribe_polish(%Scope{} = scope, id) do
    Phoenix.PubSub.subscribe(PolishMe.PubSub, polish_topic(scope, id))
  end

  defp broadcast(%Scope{} = scope, message) do
    Phoenix.PubSub.broadcast(PolishMe.PubSub, all_topic(scope), message)
  end

  defp broadcast_polish(scope, id, message) do
    Phoenix.PubSub.broadcast(PolishMe.PubSub, polish_topic(scope, id), message)
  end

  defp all_topic(scope), do: "user:#{scope.user.id}:stash_polishes"
  defp polish_topic(scope, id), do: "user:#{scope.user.id}:stash_polish:#{id}"

  @doc """
  Returns the list of stash_polishes.

  ## Examples

      iex> list_stash_polishes(scope)
      [%StashPolish{}, ...]

  """
  def list_stash_polishes(%Scope{} = scope) do
    StashPolish
    |> where(user_id: ^scope.user.id)
    |> Repo.all()
    |> preload_polish_and_brand()
  end

  @doc """
  Gets a single stash_polish.

  Raises `Ecto.NoResultsError` if the Stashed Polish does not exist.

  ## Examples

      iex> get_stash_polish!(scope, 123)
      %StashPolish{}

      iex> get_stash_polish!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_stash_polish!(%Scope{} = scope, brand_slug, polish_slug) do
    StashPolish
    |> join(:inner, [sp], p in assoc(sp, :polish))
    |> join(:inner, [_sp, p], b in assoc(p, :brand))
    |> where(user_id: ^scope.user.id)
    |> where([_sp, p, b], b.slug == ^brand_slug and p.slug == ^polish_slug)
    |> Repo.one!()
    |> preload_polish_and_brand()
  end

  @doc """
  Creates a stash_polish.

  ## Examples

      iex> create_stash_polish(scope, %{field: value})
      {:ok, %StashPolish{}}

      iex> create_stash_polish(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_stash_polish(%Scope{} = scope, attrs \\ %{}) do
    with {:ok, stash_polish = %StashPolish{}} <-
           %StashPolish{}
           |> StashPolish.changeset(attrs, scope)
           |> Repo.insert() do
      stash_polish = stash_polish |> preload_polish_and_brand()
      broadcast(scope, {:created, stash_polish})
      {:ok, stash_polish}
    end
  end

  @doc """
  Updates a stash_polish.

  ## Examples

      iex> update_stash_polish(scope, stash_polish, %{field: new_value})
      {:ok, %StashPolish{}}

      iex> update_stash_polish(scope, stash_polish, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_stash_polish(%Scope{} = scope, %StashPolish{} = stash_polish, attrs) do
    true = stash_polish.user_id == scope.user.id

    with {:ok, stash_polish = %StashPolish{}} <-
           stash_polish
           |> StashPolish.changeset(attrs, scope)
           |> Repo.update() do
      broadcast(scope, {:updated, stash_polish})
      broadcast_polish(scope, stash_polish.id, {:updated, stash_polish})
      {:ok, stash_polish}
    end
  end

  @doc """
  Deletes a stash_polish.

  ## Examples

      iex> delete_stash_polish(scope, stash_polish)
      {:ok, %StashPolish{}}

      iex> delete_stash_polish(scope, stash_polish)
      {:error, %Ecto.Changeset{}}

  """
  def delete_stash_polish(%Scope{} = scope, %StashPolish{} = stash_polish) do
    true = stash_polish.user_id == scope.user.id

    with {:ok, stash_polish = %StashPolish{}} <-
           Repo.delete(stash_polish) do
      broadcast(scope, {:deleted, stash_polish})
      broadcast_polish(scope, stash_polish.id, {:deleted, stash_polish})
      {:ok, stash_polish}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking stash_polish changes.

  ## Examples

      iex> change_stash_polish(scope, stash_polish)
      %Ecto.Changeset{data: %StashPolish{}}

  """
  def change_stash_polish(%Scope{} = scope, %StashPolish{} = stash_polish, attrs \\ %{}) do
    true = stash_polish.user_id == scope.user.id

    StashPolish.changeset(stash_polish, attrs, scope)
  end

  defp preload_polish_and_brand(stash_polish) do
    b_query = Brand |> select([:name, :slug])
    p_query = Polish |> select([:name, :slug, :brand_id])
    stash_polish |> Repo.preload(polish: {p_query, [brand: b_query]})
  end

  def get_statuses() do
    StashPolish |> Ecto.Enum.values(:status)
  end
end
