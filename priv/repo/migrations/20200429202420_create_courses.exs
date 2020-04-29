defmodule Nordref.Repo.Migrations.CreateCourses do
  use Ecto.Migration

  def up do
    execute """
    CREATE TYPE nordref.course_type AS ENUM (
      'F',
      'J',
      'G2',
      'G3'
    )
    """

    create table(:courses, prefix: :nordref) do
      add :name, :text, null: false
      add :max_participants, :integer, null: false, default: 20
      add :max_per_club, :integer, null: false, default: 6
      add :max_organizer_participants, :integer, null: false, default: 6
      add :organizer_id, references(:clubs), null: false
      add :season_id, references(:seasons, column: :year), null: false
      add :date, :naive_datetime, null: false
      add :released, :boolean

      timestamps()
    end

    execute "ALTER TABLE nordref.courses ADD COLUMN type nordref.course_type NOT NULL"
  end

  def down do
    drop_if_exists table(:courses, prefix: :nordref)
    execute "DROP TYPE IF EXISTS nordref.course_type"
  end
end
