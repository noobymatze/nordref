defmodule Nordref.Repo.Migrations.SetSeason do
  use Ecto.Migration

  def up do
    execute """
    INSERT INTO seasons
      (year, start, end, start_registration, end_registration)
    VALUES
      (2019, '2019-03-01 00:00:00', '2020-02-29 00:00:00', '2020-03-01 00:00:00', '2020-02-29 00:00:00');
    """
  end

  def down do
    execute """
    DELETE FROM seasons s WHERE s.year = 2019;
    """
  end
end
