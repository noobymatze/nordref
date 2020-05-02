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
    query =
    from c in Association,
      order_by: c.name,
      select: c

    Repo.all(query)
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

  @doc """
  Gets a single association.

  Raises if the Association does not exist.

  ## Examples

      iex> get_association!(123)
      %Association{}

  """
  def get_association!(id), do: Repo.get!(Association, id)

  @doc """
  Updates a association.

  ## Examples

      iex> update_association(association, %{field: new_value})
      {:ok, %Association{}}

      iex> update_association(association, %{field: bad_value})
      {:error, ...}

  """
  def update_association(%Association{} = association, attrs) do
    association
    |> Association.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Association.

  ## Examples

      iex> delete_association(association)
      {:ok, %Association{}}

      iex> delete_association(association)
      {:error, ...}

  """
  def delete_association(%Association{} = association) do
    Repo.delete(association)
  end

  @doc """
  Returns a data structure for tracking association changes.

  ## Examples

      iex> change_association(association)
      %Todo{...}

  """
  def change_association(%Association{} = association, _attrs \\ %{}) do
    Association.changeset(association, %{})
  end
end
