defmodule Nordref.Seasons.Season do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:year, :integer, autogenerate: false}
  @derive {Phoenix.Param, key: :year}
  schema "seasons" do
    field :end, :naive_datetime
    field :end_registration, :naive_datetime
    field :start, :naive_datetime
    field :start_registration, :naive_datetime

    timestamps(inserted_at: :created_at)
  end

  @doc false
  def changeset(season, attrs) do
    season
    |> cast(attrs, [:year, :start, :end, :start_registration, :end_registration])
    |> validate_required([:year, :start, :end, :start_registration, :end_registration])
  end
end
