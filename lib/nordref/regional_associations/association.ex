defmodule Nordref.Associations.Association do
  use Ecto.Schema
  import Ecto.Changeset

  schema "associations" do
    field :name, :string
    field :email, :string

    timestamps()
  end

  @doc false
  def changeset(association, attrs) do
    association
    |> cast(attrs, [:name, :email])
    |> validate_required([:name])
  end
end
