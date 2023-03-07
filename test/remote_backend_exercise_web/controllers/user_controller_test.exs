defmodule RemoteBackendExerciseWeb.UserControllerTest do
  use RemoteBackendExerciseWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "list users and points", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      response = json_response(conn, 200)
      # Make sure response formatted properly
      assert %{"timestamp" => timestamp, "users" => users} = response
      assert timestamp == nil || is_binary(timestamp)
      assert is_list(users)

      conn = get(conn, Routes.user_path(conn, :index))
      response = json_response(conn, 200)
      assert %{"timestamp" => timestamp, "users" => users} = response
      # second time timestamp should not be nil
      assert timestamp != nil && is_binary(timestamp)
      assert is_list(users)
    end
  end
end
