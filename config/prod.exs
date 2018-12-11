use Mix.Config
# set params below according to the IP and PORT of your management server (Must be HTTPS)
config :cp_mgmt, mgmt_server_url: "https://192.168.0.8:443"
config :cp_mgmt, mgmt_user: "admin"
config :cp_mgmt, mgmt_pass: "vpn123"
config :cp_mgmt, mgmt_domain: nil

# Set this paramater for what Adapter Tesla will use (hackney is recommended)
# If your management server has an authenticate certification uncomment the line below and comment out
# the currently active line

# config :tesla, adapter: Tesla.Adapter.Hackney
config :tesla, :adapter, {Tesla.Adapter.Hackney, [insecure: true]}
