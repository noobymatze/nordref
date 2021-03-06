defmodule Nordref.Repo.Migrations.CreateLicenses do
  use Ecto.Migration

  def up do
    execute """
    CREATE TYPE nordref.license_type AS ENUM (
      'N1','N2','N3','N4','L1','L2','L3','LJ'
    )
    """

    create table(:licenses, prefix: :nordref) do
      add :number, :integer, null: false
      add :season, references(:seasons, column: :year), null: false
      add :user_id, references(:users), null: false
      timestamps()
    end

    execute "ALTER TABLE nordref.licenses ADD COLUMN type nordref.license_type NOT NULL"
  end

  def down do
    drop_if_exists table(:licenses, prefix: :nordref)
    execute "DROP TYPE IF EXISTS nordref.license_type"
  end
end
