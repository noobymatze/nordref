defmodule Nordref.Clubs.Club do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clubs" do
    field :name, :string
    field :regional_association, :string
    field :short_name, :string
  end

  @doc false
  def changeset(club, attrs) do
    club
    |> cast(attrs, [:name, :short_name, :regional_association])
    |> validate_required([:name, :short_name, :regional_association])
  end

  @doc false
  def regional_associations do
    ["FVN", "FLV-SH", "BFB", "FBHH", "FD"]
  end
end
