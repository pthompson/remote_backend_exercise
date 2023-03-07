defmodule RemoteBackendExercise.RandomGenServer do
  @moduledoc """
  GenServer to meet Remote.com take home exercise requirements:
  - When the app starts, a `genserver` should be launched which will:
    - Have 2 elements as state:
        - A random number (let's call it the `min_number`), [0 - 100]
        - A timestamp (which indicates the last time someone queried the genserver, defaults to `nil` for the first query)
    - Run every minute and when it runs:
        - Should update every user's points in the database (using a random number generator [0-100] for each)
        - Refresh the `min_number` of the genserver state with a new random number
    - Should accept a `handle_call` that:
        - Queries the database for all users with more points than `min_number` but only retrieve a max of 2 users.
        - Updates the genserver state `timestamp` with the current timestamp
        - Returns the users just retrieved from the database, as well as the timestamp of the **previous `handle_call`**
  """

  use GenServer

  alias RemoteBackendExercise.Users

  @points_range 0..100
  @refresh_time :timer.seconds(60)
  @get_user_limit 2

  @doc """
  Returns %{users: users, timestamp: timestamp} where
  users is a list of max 2 users with more points than internal min_number and
  timestamp is the time of the previous call to get_users
  """
  def get_users do
    GenServer.call(__MODULE__, {:get_users})
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @impl true
  def init(_) do
    state = %{
      min_number: 0,
      timestamp: nil
    }

    {:ok, state, {:continue, :finish_init}}
  end

  @impl true
  def handle_continue(:finish_init, %{timestamp: timestamp}) do
    randomize_user_points()
    schedule_refresh()

    state = %{
      min_number: Enum.random(@points_range),
      timestamp: timestamp
    }

    {:noreply, state}
  end

  @impl true
  def handle_call({:get_users}, _from, %{min_number: min_number, timestamp: timestamp}) do
    users = Users.get_users_with_more_points_than_min(min_number, @get_user_limit)

    response = %{
      users: users,
      timestamp: timestamp
    }

    state = %{
      min_number: min_number,
      timestamp: DateTime.utc_now()
    }

    {:reply, response, state}
  end

  @impl true
  def handle_info(:refresh, %{timestamp: timestamp}) do
    # Randomizes all users' points and updates min_number to new random number
    randomize_user_points()

    state = %{
      min_number: Enum.random(@points_range),
      timestamp: timestamp
    }

    # Schedule next refresh
    schedule_refresh()

    {:noreply, state}
  end

  defp randomize_user_points do
    Users.randomize_user_points()
  end

  defp schedule_refresh do
    # Schedule next refresh after @refresh_time
    Process.send_after(self(), :refresh, @refresh_time)
  end
end
