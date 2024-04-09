defmodule DaliboTest.Repo do
  use Ecto.Repo,
    otp_app: :dalibo_test,
    adapter: Ecto.Adapters.Postgres

  def explain_analyze(fragment) do
    {query, _} = Ecto.Adapters.SQL.to_sql(:all, __MODULE__, fragment)

    explain_query = "EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON) " <> query

    {:ok, %Postgrex.Result{rows: [[[json]]]}} =
      Ecto.Adapters.SQL.query(__MODULE__, explain_query, [])

    plan = Jason.encode!(json)

    response =
      Req.post!(
        "https://explain.dalibo.com/new",
        json: %{
          plan: plan,
          query: query,
          title: DateTime.utc_now() |> DateTime.to_string()
        },
        headers: [{"Content-Type", "application/json"}],
        redirect: false
      )

    case response.status do
      302 ->
        [location | _] = response.headers["location"]
        IO.puts("https://explain.dalibo.com" <> location)

      _ ->
        raise "Failed to upload to Dalibo!"
    end
  end
end
