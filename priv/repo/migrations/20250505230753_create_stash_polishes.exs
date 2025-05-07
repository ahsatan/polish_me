defmodule PolishMe.Repo.Migrations.CreateStashPolishes do
  use Ecto.Migration

  def change do
    create table(:stash_polishes) do
      add :status, :string, null: false
      add :thoughts, :text
      add :fill_percent, :integer, default: 100, null: false
      add :purchase_price, :integer
      add :purchase_date, :date
      add :swatched, :boolean, default: false, null: false

      add :polish_id, references(:polishes), null: false
      add :user_id, references(:users, type: :id, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:stash_polishes, [:polish_id])
    create index(:stash_polishes, [:user_id])
    create unique_index(:stash_polishes, [:user_id, :polish_id])
  end
end
