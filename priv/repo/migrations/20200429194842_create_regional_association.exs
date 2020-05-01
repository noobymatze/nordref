defmodule Nordref.Repo.Migrations.CreateRegionalAssociation do
  use Ecto.Migration

  def change do
    create table(:regional_associations, prefix: :nordref) do
      add :name, :text, null: false
      add :email, :text
      timestamps()
    end
  end
end
