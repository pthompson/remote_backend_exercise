defmodule RemoteBackendExercise.UsersTest do
  use RemoteBackendExercise.DataCase

  alias RemoteBackendExercise.Users

  describe "users" do
    alias RemoteBackendExercise.Users.User

    import RemoteBackendExercise.UsersFixtures

    @valid_points_range 0..100
    @out_of_range_points %{points: Enum.max(@valid_points_range) + 1}
    @invalid_attrs %{points: nil}

    test "list_users/0 returns all users" do
      users = Users.list_users()
      all_user_points = Enum.map(users, & &1.points)
      assert all_user_points == [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{points: 42}

      assert {:ok, %User{} = user} = Users.create_user(valid_attrs)
      assert user.points == 42
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end

    test "create_user/1 with out of range data returns error changeset" do
      assert {:error,
              %Ecto.Changeset{
                errors: [points: {"is invalid", [validation: :inclusion, enum: 0..100]}]
              }} = Users.create_user(@out_of_range_points)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{points: 43}

      assert {:ok, %User{} = user} = Users.update_user(user, update_attrs)
      assert user.points == 43
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)
      assert user == Users.get_user!(user.id)
    end

    test "update_user/2 with out of range points returns error changeset" do
      user = user_fixture()

      assert {:error,
              %Ecto.Changeset{
                errors: [points: {"is invalid", [validation: :inclusion, enum: 0..100]}]
              }} = Users.update_user(user, @out_of_range_points)

      assert user == Users.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Users.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Users.change_user(user)
    end

    test "randomize_user_points/0 changes user points in database" do
      # Can only check that some or all values have changed. There is
      # a slight chance that randomization will result in the exact same
      # values, in which case the test would randomly fail.
      initial_user_points =
        Users.list_users()
        |> Enum.map(& &1.points)

      assert initial_user_points == [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

      Users.randomize_user_points()

      randomized_user_points =
        Users.list_users()
        |> Enum.map(& &1.points)

      assert initial_user_points != randomized_user_points
    end

    test "get_users_with_more_points_than_min/2 returns data in expected shape" do
      [user_id_and_points_map] = Users.get_users_with_more_points_than_min(3, 1)

      assert Map.has_key?(user_id_and_points_map, :id)
      assert Map.has_key?(user_id_and_points_map, :points)
    end

    test "get_users_with_more_points_than_min/2 returns users with lowest points when min_number is negative" do
      points =
        Users.get_users_with_more_points_than_min(-1)
        |> Enum.map(& &1.points)

      assert points == [0, 1]
    end

    test "get_users_with_more_points_than_min/2 returns points for [limit] users when min_number in middle of points range" do
      points =
        Users.get_users_with_more_points_than_min(5)
        |> Enum.map(& &1.points)

      assert points == [6, 7]
    end

    test "get_users_with_more_points_than_min/2 returns points for a single user when min_number is one less than single largest point value" do
      points =
        Users.get_users_with_more_points_than_min(9)
        |> Enum.map(& &1.points)

      assert points == [10]
    end

    test "get_users_with_more_points_than_min/2 returns empty list when min_number is greater than or equal to largest point value" do
      points =
        Users.get_users_with_more_points_than_min(10)
        |> Enum.map(& &1.points)

      assert points == []
    end
  end
end
