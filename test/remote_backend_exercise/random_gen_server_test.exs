defmodule RemoteBackendExercise.RandomGenServerTest do
  @moduledoc """
  Tests for RandomGenServer. Assumes known test data seeded in database.
  """
  use RemoteBackendExercise.DataCase

  alias RemoteBackendExercise.Users

  describe "random_gen_server" do
    alias RemoteBackendExercise.RandomGenServer

    @valid_points_range 0..100

    test "get_users/2 returns a list of users and timestamp" do
      current_timestamp = DateTime.utc_now()
      %{users: users, timestamp: timestamp} = RandomGenServer.get_users()
      assert is_list(users)
      assert timestamp == nil || timestamp < current_timestamp

      # timestamp should not be nil second time
      current_timestamp = DateTime.utc_now()
      %{users: users, timestamp: timestamp} = RandomGenServer.get_users()
      assert is_list(users)
      assert timestamp != nil && timestamp < current_timestamp
    end

    test "handle_continue/2 :finish_init initializes state as expected" do
      {:noreply, state} =
        RandomGenServer.handle_continue(:finish_init, %{min_number: 0, timestamp: nil})

      assert state.timestamp == nil

      assert state.min_number in @valid_points_range
    end

    test "handle_call/3 :get_users returns expected response and updated state" do
      timestamp = DateTime.utc_now()
      min_number = 50

      {:reply, response, state} =
        RandomGenServer.handle_call({:get_users}, self(), %{
          min_number: min_number,
          timestamp: timestamp
        })

      points = Enum.map(response.users, & &1.points)
      assert points == [60, 70]

      assert response.timestamp == timestamp

      assert state.timestamp > timestamp

      assert state.min_number == min_number
    end

    test "handle_info/2 :refresh randomizes users and min_number" do
      initial_user_points =
        Users.list_users()
        |> Enum.map(& &1.points)

      assert initial_user_points == [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100]

      timestamp = DateTime.utc_now()
      min_number = 5

      {:noreply, state} =
        RandomGenServer.handle_info(:refresh, %{
          min_number: min_number,
          timestamp: timestamp
        })

      # make sure timestamp state not changed
      assert state.timestamp == timestamp

      # make sure new min_number state is valid
      assert state.min_number in @valid_points_range

      #  make sure users' points are changed
      updated_user_points =
        Users.list_users()
        |> Enum.map(& &1.points)

      assert Enum.all?(updated_user_points, &(&1 in @valid_points_range))

      # note there is a chance this fails if the randomized user points match the original in every case
      assert updated_user_points != initial_user_points
    end
  end
end
