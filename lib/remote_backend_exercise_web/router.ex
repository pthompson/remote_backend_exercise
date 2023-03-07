defmodule RemoteBackendExerciseWeb.Router do
  use RemoteBackendExerciseWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RemoteBackendExerciseWeb do
    pipe_through :api

    get "/", UserController, :index
  end
end
