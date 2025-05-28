defmodule PolishMe.Repo.Migrations.AddImageUrlToPolish do
  use Ecto.Migration

  def change do
    alter table(:polishes) do
      add :image_url, :string
    end
  end
end
