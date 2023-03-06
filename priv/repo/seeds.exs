# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#

# Create 1,000,000 seed users, each with initial points value of 0

alias RemoteBackendExercise.Users

for _ <- 1..1_000_000, do: Users.create_user(%{points: 0})
