defmodule Nordref.Repo.Migrations.CreateSeasons do
  use Ecto.Migration

  def change do
    create table(:seasons, primary_key: false, prefix: :nordref) do
      add :year, :integer, primary_key: true
      add :name, :text
      add :start, :naive_datetime, null: false
      add :end, :naive_datetime, null: false
      add :start_registration, :naive_datetime
      add :end_registration, :naive_datetime
      timestamps()
    end
  end
end
