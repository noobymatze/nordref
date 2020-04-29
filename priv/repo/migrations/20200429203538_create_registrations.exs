defmodule Nordref.Repo.Migrations.CreateRegistrations do
  use Ecto.Migration

  def change do
    create table(:registrations, prefix: :nordref) do
      add :user_id, references(:users)
      add :course_id, references(:courses)
      timestamps()
    end

  end
end
