defmodule Nordref.Repo.Migrations.CreateRegistrationsView do
  use Ecto.Migration

  def up do
    execute """
    CREATE OR REPLACE VIEW registrations_view AS (
      SELECT
          u.id         AS user_id,
          u.first_name AS first_name,
          u.last_name  AS last_name,
          u.email      AS email,
          c.id         AS club_id,
          c.name       AS club_name,
          c.short_name AS club_short_name,
          r.course_id  AS course_id,
          r.created_at AS created_at,
          r.updated_at AS updated_at
      FROM registrations r
      JOIN users u ON u.id = r.user_id
      JOIN clubs c ON c.id = u.club_id
    );
    """
  end

  def down do
    execute """
    DROP VIEW registrations_view;
    """
  end
end
