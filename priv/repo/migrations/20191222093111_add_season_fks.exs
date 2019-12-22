defmodule Nordref.Repo.Migrations.AddSeasonFks do
  use Ecto.Migration

  def up do
    execute """
    ALTER TABLE `licenses`
      ADD CONSTRAINT `fk_licenses_seasons` FOREIGN KEY (`season`) REFERENCES `seasons` (`year`);
    """

    execute """
    ALTER TABLE `courses`
      ADD COLUMN `season` INT NOT NULL DEFAULT '2019',
      ADD CONSTRAINT `fk_courses_seasons` FOREIGN KEY (`season`) REFERENCES `seasons` (`year`);
    """
  end

  def down do
    execute """
    ALTER TABLE licenses
      DROP FOREIGN KEY `fk_licenses_seasons`;
    """

    execute """
    ALTER TABLE courses
      DROP FOREIGN KEY `fk_courses_seasons`,
      DROP COLUMN `season`;
    """
  end
end
