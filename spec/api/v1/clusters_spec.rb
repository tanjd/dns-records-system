require "rails_helper"

describe "Clusters API", type: :request do
  it "returns all the clusters" do
    get "/api/v1/clusters"
    expect(response).to have_http_status(:success)

    json_response = JSON.parse(response.body)
    expect(json_response.size).to eq(4)
    expect(json_response).to contain_exactly(
      {
        "id" => 1,
        "name" => "Los Angeles",
        "subdomain" => "la",
      },
      {
        "id" => 2,
        "name" => "New York",
        "subdomain" => "nyc",
      },
      {
        "id" => 3,
        "name" => "Frankfurt",
        "subdomain" => "fra",
      },
      {
        "id" => 4,
        "name" => "Hong Kong",
        "subdomain" => "hongkong",
      }
    )
  end
end
