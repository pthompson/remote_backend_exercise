defmodule RemoteBackendExerciseWeb.UserView do
  use RemoteBackendExerciseWeb, :view

  def render("index.json", %{users: _users, timestamp: _timestamp} = users_points) do
    render_users_points(users_points)
  end

  defp render_users_points(%{users: users, timestamp: timestamp}) do
    formatted_timestamp =
      if timestamp == nil, do: nil, else: Calendar.strftime(timestamp, "%y-%m-%d %I:%M:%S")

    %{
      users: users,
      timestamp: formatted_timestamp
    }
  end
end
