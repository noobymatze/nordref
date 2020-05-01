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

end
