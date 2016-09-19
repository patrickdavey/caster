ExUnit.start

Ecto.Adapters.SQL.Sandbox.mode(Caster.Repo, :manual)
ExUnit.configure exclude: [:production_api_test]
