Application.ensure_all_started(:hound)
ExUnit.start

Ecto.Adapters.SQL.Sandbox.mode(Caster.Repo, :manual)
ExUnit.configure exclude: [:production_api_test, :skipped, :feature]
