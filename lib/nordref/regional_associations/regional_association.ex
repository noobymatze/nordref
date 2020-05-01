defmodule Nordref.RegionalAssociations.RegionalAssociation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "regional_associations" do
    field :name, :string
    field :email, :string

    timestamps()
  end

  @doc false
  def changeset(club, attrs) do
    club
    |> cast(attrs, [:name, :email])
    |> validate_required([:name])
  end
end
