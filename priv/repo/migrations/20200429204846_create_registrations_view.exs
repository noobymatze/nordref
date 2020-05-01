defmodule Nordref.Repo.Migrations.CreateRegistrationsView do
  use Ecto.Migration

  def up do
    execute """
    CREATE OR REPLACE VIEW nordref.registrations_view AS (
      SELECT
        r.id              AS id,
        u.id              AS user_id,
        u.first_name      AS first_name,
        u.last_name       AS last_name,
        u.email           AS email,
        u.birthday        AS birthday,
        c.id              AS club_id,
        c.name            AS club_name,
        c.short_name      AS club_short_name,
        co.name           AS course_name,
        co.season         AS season,
        r.course_id       AS course_id,
        lp.number         AS previous_license_number,
        l.number          AS current_license_number,
        r.inserted_at     AS inserted_at,
        r.updated_at      AS updated_at
      FROM nordref.registrations r
      JOIN nordref.users u ON u.id = r.user_id
      JOIN nordref.clubs c ON c.id = u.club_id
      JOIN nordref.courses co ON co.id = r.course_id
      LEFT JOIN nordref.licenses lp ON lp.user_id = u.id AND lp.season = (co.season - 1)
      LEFT JOIN nordref.licenses l ON l.user_id = u.id AND l.season = co.season
    );
    """
  end

  def down do
    execute """
    DROP VIEW nordref.registrations_view;
    """
  end
end
