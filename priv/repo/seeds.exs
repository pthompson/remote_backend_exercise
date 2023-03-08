# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#

# Create 1,000,000 seed users, each with initial points value of 0

alias RemoteBackendExercise.Users
alias RemoteBackendExercise.Users.User
alias RemoteBackendExercise.Repo

Repo.delete_all(User)

if Mix.env() == :dev do
  for _ <- 1..1_000_000, do: Users.create_user(%{points: 0})
end

if Mix.env() == :test do
  for n <- 0..10, do: Users.create_user(%{points: n * 10})
end
