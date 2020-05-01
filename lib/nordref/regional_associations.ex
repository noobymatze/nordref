defmodule Nordref.RegionalAssociations do
  @moduledoc """
  The RegionalAssociations context.
  """

  import Ecto.Query, warn: false
  alias Nordref.Repo

  alias Nordref.RegionalAssociations.RegionalAssociation

  @doc """
  Returns the list of regional associations.

  ## Examples

      iex> list__regional_associations()
      [%RegionalAssociations{}, ...]

  """
  def list_regional_associations do
    Repo.all(RegionalAssociation)
  end

  @doc """
  Creates a regional association.

  ## Examples

      iex> create_regional_association(%{field: value})
      {:ok, %RegionalAssociation{}}

      iex> create_regional_association(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_regional_association(attrs \\ %{}) do
    %RegionalAssociation{}
    |> RegionalAssociation.changeset(attrs)
    |> Repo.insert()
  end
end
