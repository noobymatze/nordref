defmodule Nordref.Licenses.License do
  use Ecto.Schema
  import Ecto.Changeset

  schema "licenses" do
    field :first_name, :string
    field :last_name, :string
    field :license_number, :integer
    field :license_type, :string
    field :season, :integer
    field :year_of_birth, :integer
    field :club_id, :id
    field :user_id, :id

    timestamps(inserted_at: :created_at, updated_at: false)
  end

  @doc false
  def types do
    ["N1", "N2", "N3", "N4", "L1", "L2", "L3", "LJ"]
  end

  @doc false
  def changeset(license, attrs) do
    license
    |> cast(attrs, [
      :first_name,
      :last_name,
      :license_number,
      :license_type,
      :year_of_birth,
      :season
    ])
    |> validate_required([:license_number, :license_type, :year_of_birth, :season])
    |> validate_inclusion(:license_type, types())
  end
end
