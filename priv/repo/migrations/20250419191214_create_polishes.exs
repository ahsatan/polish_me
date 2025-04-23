defmodule PolishMe.Repo.Migrations.CreatePolishes do
  use Ecto.Migration

  def change do
    create table(:polishes) do
      add :name, :string, null: false
      add :slug, :string, null: false
      add :description, :text
      add :colors, {:array, :string}
      add :finishes, {:array, :string}
      add :topper, :boolean, default: false, null: false

      add :brand_id, references(:brands), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:polishes, [:brand_id])
    create unique_index(:polishes, [:id])
    create unique_index(:polishes, [:brand_id, :slug])
    create unique_index(:polishes, [:brand_id, :name])
  end
end
