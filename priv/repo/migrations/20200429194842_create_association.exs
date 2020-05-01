defmodule Nordref.Repo.Migrations.CreateAssociation do
  use Ecto.Migration

  def change do
    create table(:associations, prefix: :nordref) do
      add :name, :text, null: false
      add :email, :text
      timestamps()
    end
  end
end
