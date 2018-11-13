defmodule CpMgmt.Host do
  @moduledoc """
  This module manages simple host functions with the Web API
  """
  use Tesla

  plug(Tesla.Middleware.BaseUrl, Application.get_env(:cp_mgmt, :mgmt_server_url))
  plug(Tesla.Middleware.JSON)
end
