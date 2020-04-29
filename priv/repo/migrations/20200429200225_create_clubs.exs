defmodule Nordref.Repo.Migrations.CreateClubs do
  use Ecto.Migration

  def change do
    create table(:clubs, prefix: :nordref) do
      add :name, :text, null: false
      add :short_name, :text
      add :regional_association_id, references(:regional_associations)
      timestamps()
    end
  end
end
