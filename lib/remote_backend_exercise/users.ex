defmodule RemoteBackendExercise.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias RemoteBackendExercise.Repo
  alias RemoteBackendExercise.Users.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  @doc """
  Updates all users' points in the database with random number from 0 to 100
  """
  def randomize_user_points do
    update(User, set: [points: fragment("floor(random()*100)")])
    |> Repo.update_all([])
  end

  @doc """
  Query database for all users with more points than min_number but restrict result to a limited number of users.
  """
  def get_users_with_more_points_than_min(min_number, limit \\ 2) do
    q =
      from u in User,
        as: :user,
        where: u.points > ^min_number,
        select: %{id: u.id, points: u.points},
        order_by: [asc: u.points],
        limit: ^limit

    Repo.all(q)
  end
end
