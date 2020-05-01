defmodule Nordref.Associations do
  @moduledoc """
  The Associations context.
  """

  import Ecto.Query, warn: false
  alias Nordref.Repo

  alias Nordref.Associations.Association

  @doc """
  Returns the list of regional associations.

  ## Examples

      iex> list_associations()
      [%Associations{}, ...]

  """
  def list_associations do
    Repo.all(Association)
  end

  @doc """
  Creates a regional association.

  ## Examples

      iex> create_association(%{field: value})
      {:ok, %Association{}}

      iex> create_association(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_association(attrs \\ %{}) do
    %Association{}
    |> Association.changeset(attrs)
    |> Repo.insert()
  end
end
