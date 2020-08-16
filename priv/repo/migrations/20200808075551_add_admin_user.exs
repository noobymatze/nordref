defmodule Nordref.Repo.Migrations.AddAdminUser do
  use Ecto.Migration

  def up do
    execute """
      INSERT INTO nordref.users (
        first_name,
        last_name,
        email,
        username,
        password,
        birthday,
        inserted_at,
        updated_at,
        role
      ) VALUES (
        '',
        'admin',
        'admin@example.de',
        'admin',
        '$2b$12$OCKMqpr2qyGxMK7rw9m9CeasntL5VEtOWiBVYcsBV0Ig63JDVWig.',
        '2020-08-08',
        NOW(),
        NOW(),
        'SUPER_ADMIN'
      )
    """
  end

  def down do
    execute """
    DELETE FROM nordref.users WHERE u.username = 'admin';
    """
  end
end
