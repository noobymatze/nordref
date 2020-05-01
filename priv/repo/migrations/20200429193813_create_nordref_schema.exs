defmodule Nordref.Repo.Migrations.CreateNordrefSchema do
  use Ecto.Migration

  def up do
    execute "CREATE SCHEMA IF NOT EXISTS nordref"
  end

  def down do
    execute "DROP SCHEMA nordref"
  end
end
