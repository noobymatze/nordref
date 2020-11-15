defmodule Nordref.Permissions do
  alias Nordref.Users.User

  @doc """
  Check, whether the given `%User{}` is allowed to perform an action.

  ## Examples

      iex> has_permission?(user, {:release_course, course})
      :ok

      iex> has_permission?(user, {:release_course, course})
      :ok
  """
  def has_permission?(%User{} = user, permission) do
    case permission do
      {:release_course, _course} ->
        User.super_admin?(user) || User.admin?(user)

      {:delete_course, _course} ->
        User.super_admin?(user) || User.admin?(user)

      :view_seasons ->
        User.super_admin?(user) || User.admin?(user)

      :create_season ->
        User.super_admin?(user) || User.admin?(user)

      :show_season ->
        User.super_admin?(user) || User.admin?(user)

      _ ->
        false
    end
  end
end
