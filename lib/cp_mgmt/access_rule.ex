defmodule CpMgmt.AccessRule do
  @moduledoc """
  This module manages simple Access Rule functions with the Web API
  """
  defstruct(status: nil, data: %{})
  alias CpMgmt.AccessRule

  @doc """
  Creates an Access rule for the specified position and layer.

  ## Examples
      iex> CpMgmt.AccessRule.add("layer-name", "rule-base-position", [name: "some-rule-name", action: "Accept"])
      {:ok,
        %CpMgmt.AccessRule{
          data: %{
            "action" => %{
              "domain" => %{
                "domain-type" => "data domain",
                "name" => "Check Point Data",
                "uid" => "a0bbbc99-adef-4ef8-bb6d-defdefdefdef"
              },
              "name" => "Drop",
              "type" => "RulebaseAction",
              "uid" => "6c488338-8eec-4103-ad21-cd461ac2c473"
            },
            "action-settings" => %{},
            "comments" => "",
            "content" => [
              %{
                "domain" => %{
                  "domain-type" => "data domain",
                  "name" => "Check Point Data",
                  "uid" => "a0bbbc99-adef-4ef8-bb6d-defdefdefdef"
                },
                "name" => "Any",
                "type" => "CpmiAnyObject",
                "uid" => "97aeb369-9aea-11d5-bd16-0090272ccb30"
              }
            ],
            "content-direction" => "any",
            "content-negate" => false,
            "custom-fields" => %{"field-1" => "", "field-2" => "", "field-3" => ""},
            "destination" => [
              %{
                "domain" => %{
                  "domain-type" => "data domain",
                  "name" => "Check Point Data",
                  "uid" => "a0bbbc99-adef-4ef8-bb6d-defdefdefdef"
                },
                "name" => "Any",
                "type" => "CpmiAnyObject",
                "uid" => "97aeb369-9aea-11d5-bd16-0090272ccb30"
              }
            ],
            "destination-negate" => false,
            "domain" => %{
              "domain-type" => "domain",
              "name" => "SMC User",
              "uid" => "41e821a0-3720-11e3-aa6e-0800200c9fde"
            },
            "enabled" => true,
            "install-on" => [
              %{
                "domain" => %{
                  "domain-type" => "data domain",
                  "name" => "Check Point Data",
                  "uid" => "a0bbbc99-adef-4ef8-bb6d-defdefdefdef"
                },
                "name" => "Policy Targets",
                "type" => "Global",
                "uid" => "6c488338-8eec-4103-ad21-cd461ac2c476"
              }
            ],
            "layer" => "b406b732-2437-4848-9741-6eae1f5bf112",
            "meta-info" => %{
              "creation-time" => %{
                "iso-8601" => "2018-11-15T11:53-0600",
                "posix" => 1542304416041
              },
              "creator" => "admin",
              "last-modifier" => "admin",
              "last-modify-time" => %{
                "iso-8601" => "2018-11-15T11:53-0600",
                "posix" => 1542304416041
              },
              "lock" => "locked by current session",
              "validation-state" => "ok"
            },
            "service" => [
              %{
                "domain" => %{
                  "domain-type" => "data domain",
                  "name" => "Check Point Data",
                  "uid" => "a0bbbc99-adef-4ef8-bb6d-defdefdefdef"
                },
                "name" => "Any",
                "type" => "CpmiAnyObject",
                "uid" => "97aeb369-9aea-11d5-bd16-0090272ccb30"
              }
            ],
            "service-negate" => false,
            "source" => [
              %{
                "domain" => %{
                  "domain-type" => "data domain",
                  "name" => "Check Point Data",
                  "uid" => "a0bbbc99-adef-4ef8-bb6d-defdefdefdef"
                },
                "name" => "Any",
                "type" => "CpmiAnyObject",
                "uid" => "97aeb369-9aea-11d5-bd16-0090272ccb30"
              }
            ],
            "source-negate" => false,
            "time" => [
              %{
                "domain" => %{
                  "domain-type" => "data domain",
                  "name" => "Check Point Data",
                  "uid" => "a0bbbc99-adef-4ef8-bb6d-defdefdefdef"
                },
                "name" => "Any",
                "type" => "CpmiAnyObject",
                "uid" => "97aeb369-9aea-11d5-bd16-0090272ccb30"
              }
            ],
            "track" => %{
              "accounting" => false,
              "alert" => "none",
              "enable-firewall-session" => false,
              "per-connection" => false,
              "per-session" => false,
              "type" => %{
                "domain" => %{
                  "domain-type" => "data domain",
                  "name" => "Check Point Data",
                  "uid" => "a0bbbc99-adef-4ef8-bb6d-defdefdefdef"
                },
                "name" => "None",
                "type" => "Track",
                "uid" => "29e53e3d-23bf-48fe-b6b1-d59bd88036f9"
              }
            },
            "type" => "access-rule",
            "uid" => "6850cda1-de4e-4743-9127-1b00cab762d2",
            "vpn" => [
              %{
                "domain" => %{
                  "domain-type" => "data domain",
                  "name" => "Check Point Data",
                  "uid" => "a0bbbc99-adef-4ef8-bb6d-defdefdefdef"
                },
                "name" => "Any",
                "type" => "CpmiAnyObject",
                "uid" => "97aeb369-9aea-11d5-bd16-0090272ccb30"
              }
            ]
          },
          status: 200
        }}

      iex> CpMgmt.AccessRule.add("layer-name", "rule-base-position", options[])
      {:error, %CpMgmt.AccessRule{status: 404, error: error}}
  """

  def add(layer, position, options \\ []) do
    params = Enum.into(options, %{layer: layer, position: position})

    CpMgmt.logged_in?()
    |> Tesla.post("/web_api/add-access-rule", params)
    |> CpMgmt.transform_response()
    |> CpMgmt.to_struct(%AccessRule{})
    |> CpMgmt.publish()
  end

  @doc """
  Removes an Access rule form the rulebase.

  ## Examples
      iex> CpMgmt.AccessRule.remove(5, "layer-name")
      {:ok, %CpMgmt.AccessRule{data: %{"message" => "OK"}, status: 200}}

      iex> CpMgmt.AccessRule.remove(5, "layer-name")
      {:error, %CpMgmt.AccessRule{status: 404, error: error}}
  """
  def remove(rule_number, layer) do
    CpMgmt.logged_in?()
    |> Tesla.post("/web_api/delete-access-rule", %{"rule-number": rule_number, layer: layer})
    |> CpMgmt.transform_response()
    |> CpMgmt.to_struct(%AccessRule{})
    |> CpMgmt.publish()
  end

  @doc """
  Show as exsisting Access rule

  ## Examples
      iex> CpMgmt.AccessRule.show(5, "layer-name")
      {:ok,
      %CpMgmt.AccessRule{
        data: %{
          "action" => %{
            "domain" => %{
              "domain-type" => "data domain",
              "name" => "Check Point Data",
              "uid" => "a0bbbc99-adef-4ef8-bb6d-defdefdefdef"
            },
            "name" => "Drop",
            "type" => "RulebaseAction",
            "uid" => "6c488338-8eec-4103-ad21-cd461ac2c473"
          },
          "action-settings" => %{},
          "comments" => "",
          "content" => [
            %{
              "domain" => %{
                "domain-type" => "data domain",
                "name" => "Check Point Data",
                "uid" => "a0bbbc99-adef-4ef8-bb6d-defdefdefdef"
              },
              "name" => "Any",
              "type" => "CpmiAnyObject",
              "uid" => "97aeb369-9aea-11d5-bd16-0090272ccb30"
            }
          ],
          "content-direction" => "any",
          "content-negate" => false,
          "custom-fields" => %{"field-1" => "", "field-2" => "", "field-3" => ""},
          "destination" => [
            %{
              "domain" => %{
                "domain-type" => "data domain",
                "name" => "Check Point Data",
                "uid" => "a0bbbc99-adef-4ef8-bb6d-defdefdefdef"
              },
              "name" => "Any",
              "type" => "CpmiAnyObject",
              "uid" => "97aeb369-9aea-11d5-bd16-0090272ccb30"
            }
          ],
          "destination-negate" => false,
          "domain" => %{
            "domain-type" => "domain",
            "name" => "SMC User",
            "uid" => "41e821a0-3720-11e3-aa6e-0800200c9fde"
          },
          "enabled" => true,
          "install-on" => [
            %{
              "domain" => %{
                "domain-type" => "data domain",
                "name" => "Check Point Data",
                "uid" => "a0bbbc99-adef-4ef8-bb6d-defdefdefdef"
              },
              "name" => "Policy Targets",
              "type" => "Global",
              "uid" => "6c488338-8eec-4103-ad21-cd461ac2c476"
            }
          ],
          "layer" => "b406b732-2437-4848-9741-6eae1f5bf112",
          "meta-info" => %{
            "creation-time" => %{
              "iso-8601" => "2018-11-15T12:03-0600",
              "posix" => 1542304983286
            },
            "creator" => "admin",
            "last-modifier" => "admin",
            "last-modify-time" => %{
              "iso-8601" => "2018-11-15T12:03-0600",
              "posix" => 1542304983286
            },
            "lock" => "unlocked",
            "validation-state" => "ok"
          },
          "service" => [
            %{
              "domain" => %{
                "domain-type" => "data domain",
                "name" => "Check Point Data",
                "uid" => "a0bbbc99-adef-4ef8-bb6d-defdefdefdef"
              },
              "name" => "Any",
              "type" => "CpmiAnyObject",
              "uid" => "97aeb369-9aea-11d5-bd16-0090272ccb30"
            }
          ],
          "service-negate" => false,
          "source" => [
            %{
              "domain" => %{
                "domain-type" => "data domain",
                "name" => "Check Point Data",
                "uid" => "a0bbbc99-adef-4ef8-bb6d-defdefdefdef"
              },
              "name" => "Any",
              "type" => "CpmiAnyObject",
              "uid" => "97aeb369-9aea-11d5-bd16-0090272ccb30"
            }
          ],
          "source-negate" => false,
          "time" => [
            %{
              "domain" => %{
                "domain-type" => "data domain",
                "name" => "Check Point Data",
                "uid" => "a0bbbc99-adef-4ef8-bb6d-defdefdefdef"
              },
              "name" => "Any",
              "type" => "CpmiAnyObject",
              "uid" => "97aeb369-9aea-11d5-bd16-0090272ccb30"
            }
          ],
          "track" => %{
            "accounting" => false,
            "alert" => "none",
            "enable-firewall-session" => false,
            "per-connection" => false,
            "per-session" => false,
            "type" => %{
              "domain" => %{
                "domain-type" => "data domain",
                "name" => "Check Point Data",
                "uid" => "a0bbbc99-adef-4ef8-bb6d-defdefdefdef"
              },
              "name" => "None",
              "type" => "Track",
              "uid" => "29e53e3d-23bf-48fe-b6b1-d59bd88036f9"
            }
          },
          "type" => "access-rule",
          "uid" => "471a5e84-be32-488e-94f3-439d6cfad5b8",
          "vpn" => [
            %{
              "domain" => %{
                "domain-type" => "data domain",
                "name" => "Check Point Data",
                "uid" => "a0bbbc99-adef-4ef8-bb6d-defdefdefdef"
              },
              "name" => "Any",
              "type" => "CpmiAnyObject",
              "uid" => "97aeb369-9aea-11d5-bd16-0090272ccb30"
            }
          ]
        },
        status: 200
      }}

      iex> CpMgmt.AccessRule.show(5, "layer-name")
      {:error, %CpMgmt.AccessRule{status: 404, error: error}}
  """

  def show(rule_number, layer) do
    CpMgmt.logged_in?()
    |> Tesla.post("/web_api/show-access-rule", %{"rule-number": rule_number, layer: layer})
    |> CpMgmt.transform_response()
    |> CpMgmt.to_struct(%AccessRule{})
  end

  @doc """
  Shows entire rulebase of specified policy name

  ## Examples
      iex> CpMgmt.AccessRule.show_rulebase("layer-name")
      {:ok,
      %CpMgmt.AccessRule{
        data: %{
          "from" => 1,
          "name" => "Network",
          "objects-dictionary" => [
            %{
              "domain" => %{
                "domain-type" => "data domain",
                "name" => "Check Point Data",
                "uid" => "a0bbbc99-adef-4ef8-bb6d-defdefdefdef"
              },
              "name" => "Any",
              "type" => "CpmiAnyObject",
              "uid" => "97aeb369-9aea-11d5-bd16-0090272ccb30"
            },
            %{
              "domain" => %{
                "domain-type" => "data domain",
                "name" => "Check Point Data",
                "uid" => "a0bbbc99-adef-4ef8-bb6d-defdefdefdef"
              },
              "name" => "Drop",
              "type" => "RulebaseAction",
              "uid" => "6c488338-8eec-4103-ad21-cd461ac2c473"
            },
            %{
              "domain" => %{
                "domain-type" => "data domain",
                "name" => "Check Point Data",
                "uid" => "a0bbbc99-adef-4ef8-bb6d-defdefdefdef"
              },
              "name" => "None",
              "type" => "Track",
              "uid" => "29e53e3d-23bf-48fe-b6b1-d59bd88036f9"
            },
            %{
              "domain" => %{
                "domain-type" => "data domain",
                "name" => "Check Point Data",
                "uid" => "a0bbbc99-adef-4ef8-bb6d-defdefdefdef"
              },
              "name" => "Policy Targets",
              "type" => "Global",
              "uid" => "6c488338-8eec-4103-ad21-cd461ac2c476"
            }
          ],
          "rulebase" => [
            %{
              "action" => "6c488338-8eec-4103-ad21-cd461ac2c473",
              "action-settings" => %{},
              "comments" => "",
              "content" => ["97aeb369-9aea-11d5-bd16-0090272ccb30"],
              "content-direction" => "any",
              "content-negate" => false,
              "custom-fields" => %{"field-1" => "", "field-2" => "", "field-3" => ""},
              "destination" => ["97aeb369-9aea-11d5-bd16-0090272ccb30"],
              "destination-negate" => false,
              "domain" => %{
                "domain-type" => "domain",
                "name" => "SMC User",
                "uid" => "41e821a0-3720-11e3-aa6e-0800200c9fde"
              },
              "enabled" => true,
              "install-on" => ["6c488338-8eec-4103-ad21-cd461ac2c476"],
              "meta-info" => %{
                "creation-time" => %{
                  "iso-8601" => "2018-11-15T12:03-0600",
                  "posix" => 1542304983286
                },
                "creator" => "admin",
                "last-modifier" => "admin",
                "last-modify-time" => %{
                  "iso-8601" => "2018-11-15T12:03-0600",
                  "posix" => 1542304983286
                },
                "lock" => "unlocked",
                "validation-state" => "ok"
              },
              "rule-number" => 1,
              "service" => ["97aeb369-9aea-11d5-bd16-0090272ccb30"],
              "service-negate" => false,
              "source" => ["97aeb369-9aea-11d5-bd16-0090272ccb30"],
              "source-negate" => false,
              "time" => ["97aeb369-9aea-11d5-bd16-0090272ccb30"],
              "track" => %{
                "accounting" => false,
                "alert" => "none",
                "enable-firewall-session" => false,
                "per-connection" => false,
                "per-session" => false,
                "type" => "29e53e3d-23bf-48fe-b6b1-d59bd88036f9"
              },
              "type" => "access-rule",
              "uid" => "471a5e84-be32-488e-94f3-439d6cfad5b8",
              "vpn" => ["97aeb369-9aea-11d5-bd16-0090272ccb30"]
            },
            %{
              "action" => "6c488338-8eec-4103-ad21-cd461ac2c473",
              "action-settings" => %{},
              "comments" => "",
              "content" => ["97aeb369-9aea-11d5-bd16-0090272ccb30"],
              "content-direction" => "any",
              "content-negate" => false,
              "custom-fields" => %{"field-1" => "", "field-2" => "", "field-3" => ""},
              "destination" => ["97aeb369-9aea-11d5-bd16-0090272ccb30"],
              "destination-negate" => false,
              "domain" => %{
                "domain-type" => "domain",
                "name" => "SMC User",
                "uid" => "41e821a0-3720-11e3-aa6e-0800200c9fde"
              },
              "enabled" => true,
              "install-on" => ["6c488338-8eec-4103-ad21-cd461ac2c476"],
              "meta-info" => %{
                "creation-time" => %{
                  "iso-8601" => "2018-09-13T19:46-0500",
                  "posix" => 1536885977621
                },
                "creator" => "System",
                "last-modifier" => "System",
                "last-modify-time" => %{
                  "iso-8601" => "2018-09-13T19:46-0500",
                  "posix" => 1536885977621
                },
                "lock" => "unlocked",
                "validation-state" => "ok"
              },
              "name" => "Cleanup rule",
              "rule-number" => 2,
              "service" => ["97aeb369-9aea-11d5-bd16-0090272ccb30"],
              "service-negate" => false,
              "source" => ["97aeb369-9aea-11d5-bd16-0090272ccb30"],
              "source-negate" => false,
              "time" => ["97aeb369-9aea-11d5-bd16-0090272ccb30"],
              "track" => %{
                "accounting" => false,
                "alert" => "none",
                "enable-firewall-session" => false,
                "per-connection" => false,
                "per-session" => false,
                "type" => "29e53e3d-23bf-48fe-b6b1-d59bd88036f9"
              },
              "type" => "access-rule",
              "uid" => "3bb62c4d-97e2-4b68-bde9-e2027b439332",
              "vpn" => ["97aeb369-9aea-11d5-bd16-0090272ccb30"]
            }
          ],
          "to" => 2,
          "total" => 2,
          "uid" => "b406b732-2437-4848-9741-6eae1f5bf112"
        },
        status: 200
      }}

      iex> CpMgmt.AccessRule.show_rulebase("standard")
      {:error, %CpMgmt.AccessRule{status: 404, error: error}}
  """
  def show_rulebase(name) do
    CpMgmt.logged_in?()
    |> Tesla.post("/web_api/show-access-rulebase", %{name: name})
    |> CpMgmt.transform_response()
    |> CpMgmt.to_struct(%AccessRule{})
  end
end
