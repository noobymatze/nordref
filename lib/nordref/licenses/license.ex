defmodule Nordref.Licenses.License do
  use Ecto.Schema
  import Ecto.Changeset

  schema "licenses" do
    field :number, :integer
    field :type, :string
    field :season, :integer
    field :user_id, :id

    timestamps()
  end

  @doc false
  def types do
    ["N1", "N2", "N3", "N4", "L1", "L2", "L3", "LJ"]
  end

  @doc false
  def changeset(license, attrs) do
    license
    |> cast(attrs, [
      :number,
      :type,
      :season,
      :user_id
    ])
    |> validate_required([:number, :type, :season, :user_id])
    |> validate_inclusion(:type, types())
  end
end
