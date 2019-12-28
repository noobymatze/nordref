defmodule Nordref.Users.Security do
  @doc """
  Hash the given input with a randomly generated salt.

  ## Examples

      iex> hash("secret")
      "$2b$12$qTJTOVlGG1FKfUhZ1Dt/CeXRO6vyYrtOAI5HM6d2bahtir3eQGwMS"

  """
  def hash(input) do
    Bcrypt.hash_pwd_salt(input)
  end

  @doc """
  Check if the given password is the given hash.

  ## Examples

      iex> verify("secret", hash("secret"))
      true

      iex> verify("wrong", hash("secret"))
      false
  """
  def verify(password, hash) do
    Bcrypt.verify_pass(password, hash)
  end
end
