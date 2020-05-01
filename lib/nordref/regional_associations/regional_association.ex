defmodule Nordref.RegionalAssociations.RegionalAssociation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "regional_associations" do
    field :name, :string
    field :email, :string

    timestamps()
  end
end
