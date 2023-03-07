defmodule RemoteBackendExerciseWeb.UserController do
  use RemoteBackendExerciseWeb, :controller

  alias RemoteBackendExercise.RandomGenServer

  action_fallback RemoteBackendExerciseWeb.FallbackController

  def index(conn, _params) do
    users_and_points = RandomGenServer.get_users()
    render(conn, "index.json", users_and_points)
  end
end
