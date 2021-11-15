require "rails_helper"

describe "Servers API", type: :request do
  it "returns all the servers and are matched" do
    get "/api/v1/servers"
    expect(response).to have_http_status(:success)

    json_response = JSON.parse(response.body)
    expect(json_response.size).to eq(6)
    expect(json_response).to contain_exactly(
      {
        "id" => 1,
        "friendly_name" => "ubiq-1",
        "ip_string" => "123.123.123.123",
        "domain_string" => "la.domain.com.",
        "cluster" => {
          "id" => 1,
          "name" => "Los Angeles",
          "subdomain" => "la",
        },
      },
      {
        "id" => 2,
        "friendly_name" => "ubiq-2",
        "ip_string" => "125.125.125.125",
        "domain_string" => "la.domain.com.",
        "cluster" => {
          "id" => 1,
          "name" => "Los Angeles",
          "subdomain" => "la",
        },
      },
      {
        "id" => 3,
        "friendly_name" => "leaseweb-de-1",
        "ip_string" => "12.12.12.12",
        "domain_string" => nil,
        "cluster" => {
          "id" => 3,
          "name" => "Frankfurt",
          "subdomain" => "fra",
        },
      },
      {
        "id" => 4,
        "friendly_name" => "rackspace-1",
        "ip_string" => "234.234.234.234",
        "domain_string" => nil,
        "cluster" => {
          "id" => 4,
          "name" => "Hong Kong",
          "subdomain" => "hongkong",
        },
      },
      {
        "id" => 5,
        "friendly_name" => "rackspace-2",
        "ip_string" => "235.235.235.235",
        "domain_string" => nil,
        "cluster" => {
          "id" => 4,
          "name" => "Hong Kong",
          "subdomain" => "hongkong",
        },
      },
      {
        "id" => 6,
        "friendly_name" => "example-1",
        "ip_string" => "12.12.12.12",
        "domain_string" => nil,
        "cluster" => {
          "id" => 4,
          "name" => "Hong Kong",
          "subdomain" => "hongkong",
        },
      },
    )
  end
end
