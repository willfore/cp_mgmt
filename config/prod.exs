use Mix.Config
# below stores the parameters to your first login for re-use with other commands
config :cp_mgmt, :api,
  sid: "",
  uid: "",
  timeout: 600

# set params below according to the location of your management server
config :cp_mgmt, mgmt_server_url: "https://192.168.0.8:443"

# Set this paramater for what Adapter Tesla will use (hackney is recommended)
# If your management server has an authenticate certification uncomment the line below and comment out
# the currently active line

# config :tesla, adapter: Tesla.Adapter.Hackney
config :tesla, :adapter, {Tesla.Adapter.Hackney, [insecure: true]}
