ExUnit.start()
Application.put_env(:wallaby, :base_url, DemoWeb.Endpoint.url())
{:ok, _} = Application.ensure_all_started(:hound)
