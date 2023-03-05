defmodule RemoteBackendExercise.Repo do
  use Ecto.Repo,
    otp_app: :remote_backend_exercise,
    adapter: Ecto.Adapters.Postgres
end
