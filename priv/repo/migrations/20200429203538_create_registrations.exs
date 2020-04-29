defmodule Nordref.Repo.Migrations.CreateRegistrations do
  use Ecto.Migration

  def change do
    create table(:registrations, prefix: :nordref, primary_key: false) do
      add :user_id, references(:users), primary_key: true
      add :course_id, references(:courses), primary_key: true
      timestamps()
    end

  end
end
