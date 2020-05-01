defmodule Nordref.Clubs.Club do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clubs" do
    field :name, :string
    field :short_name, :string
    field :association_id, :id

    timestamps()
  end

  @doc false
  def changeset(club, attrs) do
    club
    |> cast(attrs, [:name, :short_name, :association_id])
    |> validate_required([:name, :short_name, :association_id])
    |> validate_length(:short_name, max: 10)
  end
end
