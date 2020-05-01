defmodule Nordref.Clubs.Club do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clubs" do
    field :name, :string
    field :regional_association_id, :id
    field :short_name, :string

    timestamps()
  end

  @doc false
  def changeset(club, attrs) do
    club
    |> cast(attrs, [:name, :short_name, :regional_association_id])
    |> validate_required([:name, :short_name, :regional_association_id])
    |> validate_length(:short_name, max: 10)
  end
end
