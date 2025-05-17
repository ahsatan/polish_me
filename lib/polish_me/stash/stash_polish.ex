defmodule PolishMe.Stash.StashPolish do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stash_polishes" do
    field :status, Ecto.Enum,
      values: [:in_stash, :panned, :destash, :destashed, :broken, :lost],
      default: :in_stash

    field :thoughts, :string
    field :fill_percent, :integer, default: 100
    field :purchase_price, Money.Ecto.Amount.Type
    field :purchase_date, :date
    field :swatched, :boolean, default: false

    field :polish_id, :integer, writable: :insert
    belongs_to :polish, PolishMe.Polishes.Polish, define_field: false

    field :user_id, :integer, writable: :insert
    belongs_to :user, PolishMe.Accounts.User, define_field: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(stash_polish, attrs, user_scope) do
    stash_polish
    |> cast(attrs, [
      :status,
      :thoughts,
      :fill_percent,
      :purchase_price,
      :purchase_date,
      :swatched,
      :polish_id
    ])
    |> validate_required([
      :status,
      :fill_percent,
      :swatched,
      :polish_id
    ])
    |> put_change(:user_id, user_scope.user.id)
    |> validate_number(:fill_percent, greater_than_or_equal_to: 0, less_than_or_equal_to: 100)
    |> validate_thoughts()
    |> unsafe_validate_unique([:polish_id, :user_id], PolishMe.Repo,
      message: "stashed polish must be unique per user"
    )
    |> unique_constraint([:user_id, :polish_id])
  end

  defp validate_thoughts(changeset) do
    changeset
    |> validate_length(:thoughts, max: 1024)
    |> update_change(:thoughts, &if(&1, do: String.trim(&1), else: &1))
  end
end
