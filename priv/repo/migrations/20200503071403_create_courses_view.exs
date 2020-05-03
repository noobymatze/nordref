defmodule Nordref.Repo.Migrations.CreateCoursesView do
  use Ecto.Migration

  def up do
    execute """
    CREATE OR REPLACE VIEW nordref.courses_view AS (
      SELECT
        c.id as id,
        c.name as name,
        c.date as date,
        c.inserted_at as inserted_at,
        c.updated_at as updated_at,
        c.max_organizer_participants as max_organizer_participants,
        c.max_participants as max_participants,
        c.max_per_club as max_per_club,
        c.released as released,
        c.season as season,
        c.type as type,
        c.organizer_id as organizer_id,
        c2.name as club_name,
        c2.short_name as club_short_name,
        c2.association_id as club_association_id
      FROM courses c
      JOIN clubs c2 ON c.organizer_id = c2.id
    );
    """
  end

  def down do
    execute """
    DROP VIEW nordref.courses_view;
    """
  end
end
