defmodule Nordref.Seasons do
  @moduledoc """
  The Seasons context.
  """

  import Ecto.Query, warn: false
  alias Nordref.Repo

  alias Nordref.Seasons.Season

  @doc """
  Returns the list of seasons.

  ## Examples

      iex> list_seasons()
      [%Season{}, ...]

  """
  def list_seasons do
    Repo.all(Season)
  end

  @doc """
  Check whether the registration for this season is opened.

  ## Examples

    iex>registration_open?(season)
    true

  """
  def registration_open?(%Season{} = season) do
    now = NaiveDateTime.utc_now()

    # If the start_registration is nil, we presume,
    # registrations are not allowed
    if season.start_registration == nil do
      false
    else
      between?(now, season.start_registration, season.end_registration)
    end
  end

  defp between?(date, start, ending, inclusive \\ true) do
    cds =
      if start == nil do
        :lt
      else
        NaiveDateTime.compare(start, date)
      end

    cde =
      if ending == nil do
        :gt
      else
        NaiveDateTime.compare(date, ending)
      end

    if inclusive do
      (cds == :lt or cds == :eq) and (cde == :gt or cde == :eq)
    else
      cds == :lt and cde == :gt
    end
  end

  @doc """
  Gets a single season.

  Raises `Ecto.NoResultsError` if the Season does not exist.

  ## Examples

      iex> get_season!(123)
      %Season{}

      iex> get_season!(456)
      ** (Ecto.NoResultsError)

  """
  def get_season!(id), do: Repo.get!(Season, id)

  @doc """
  Creates a season.

  ## Examples

      iex> create_season(%{field: value})
      {:ok, %Season{}}

      iex> create_season(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_season(attrs \\ %{}) do
    %Season{}
    |> Season.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a season.

  ## Examples

      iex> update_season(season, %{field: new_value})
      {:ok, %Season{}}

      iex> update_season(season, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_season(%Season{} = season, attrs) do
    season
    |> Season.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Season.

  ## Examples

      iex> delete_season(season)
      {:ok, %Season{}}

      iex> delete_season(season)
      {:error, %Ecto.Changeset{}}

  """
  def delete_season(%Season{} = season) do
    Repo.delete(season)
  end

  @doc """
  Returns the current season.
  """
  def current_season() do
    now = NaiveDateTime.utc_now()

    query =
      from s in Season,
        where: s.start <= ^now and ^now <= s.end,
        select: s

    Repo.one(query)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking season changes.

  ## Examples

      iex> change_season(season)
      %Ecto.Changeset{source: %Season{}}

  """
  def change_season(%Season{} = season) do
    Season.changeset(season, %{})
  end
end
