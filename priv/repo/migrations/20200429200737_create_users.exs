defmodule Nordref.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def up do
    execute """
    CREATE TYPE nordref.role AS ENUM (
      'SUPER_ADMIN',
      'ADMIN',
      'CLUB_ADMIN',
      'INSTRUCTOR',
      'USER'
    )
    """

    create table(:users, prefix: :nordref) do
      add :first_name, :text
      add :last_name, :text, null: false
      add :email, :text
      add :username, :text, null: false
      add :password, :text
      add :birthday, :date
      add :mobile, :text
      add :phone, :text
      add :club_id, references(:clubs)

      timestamps()
    end

    execute "ALTER TABLE nordref.users ADD COLUMN role nordref.role NOT NULL DEFAULT 'USER'"
  end

  def down do
    drop_if_exists table(:users, prefix: :nordref)
    execute "DROP TYPE IF EXISTS nordref.role"
  end
end
