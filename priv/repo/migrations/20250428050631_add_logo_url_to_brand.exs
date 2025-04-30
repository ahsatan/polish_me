defmodule PolishMe.Repo.Migrations.AddLogoUrlToBrand do
  use Ecto.Migration

  def change do
    alter table(:brands) do
      add :image_url, :string
    end
  end
end
