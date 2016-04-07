ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Niles.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Niles.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Niles.Repo)

