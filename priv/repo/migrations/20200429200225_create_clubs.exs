defmodule Nordref.Repo.Migrations.CreateClubs do
  use Ecto.Migration

  def change do
    create table(:clubs, prefix: :nordref) do
      add :name, :text, null: false
      add :short_name, :text
      add :association_id, references(:associations)
      timestamps()
    end
  end
end
