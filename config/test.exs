use Mix.Config

config :cp_mgmt, mgmt_server_url: "http://example.com"
config :cp_mgmt, mgmt_user: "admin"
config :cp_mgmt, mgmt_pass: "vpn123"
# Set this paramater for what Adapter Tesla will use (hackney is recommended)
config :tesla, adapter: Tesla.Mock
