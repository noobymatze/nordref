defmodule Nordref.Repo.Migrations.CreateMyCoursesView do
  use Ecto.Migration

  def up do
    execute """
    CREATE OR REPLACE VIEW nordref.my_courses_view AS (
      SELECT
        c.id as id,
        c.name as name,
        c.date as date,
        c.season as season,
        c.type as type,
        u.id as user_id,
        c.organizer_id as organizer_id,
        cl.name as club_name,
        cl.short_name as club_short_name,
        cl.association_id as club_association_id
      FROM registrations r
      JOIN courses c ON r.course_id = c.id
      JOIN clubs cl ON c.organizer_id = cl.id
      JOIN users u ON u.id = r.user_id
    );
    """
  end

  def down do
    execute """
    DROP VIEW nordref.my_courses_view;
    """
  end
end
