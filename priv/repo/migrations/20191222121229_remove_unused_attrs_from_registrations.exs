defmodule Nordref.Repo.Migrations.RemoveUnusedAttrsFromRegistrations do
  use Ecto.Migration

  def up do
    execute """
    ALTER TABLE registrations
      DROP COLUMN email,
      DROP COLUMN first_name,
      DROP COLUMN last_name,
      DROP COLUMN birthday,
      DROP COLUMN club_id,
      DROP COLUMN license_number;
    """
  end
end
