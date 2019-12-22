defmodule Nordref.Repo.Migrations.CreateSeasons do
  use Ecto.Migration

  def change do
    create table(:seasons, primary_key: false) do
      add :year, :integer, primary_key: true
      add :start, :naive_datetime
      add :end, :naive_datetime
      add :start_registration, :naive_datetime
      add :end_registration, :naive_datetime
      add :created_at, :naive_datetime, default: fragment("NOW()")
      add :updated_at, :naive_datetime, default: fragment("NOW()")
    end
  end
end
