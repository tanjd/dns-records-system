require "rails_helper"

describe "Hosted_servers API", type: :request do
  describe "GET /hosted_servers" do
    it "return all hosted_servers and matched with servers" do
      get "/api/v1/hosted_servers"
      expect(response).to have_http_status(:success)

      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(3)
      expect(json_response).to contain_exactly(
        {
          "ip_string" => "5.5.5.5",
          "domain_string" => "eyz.domain.com.",
        },
        {
          "ip_string" => "123.123.123.123",
          "domain_string" => "la.domain.com.",
          "friendly_name" => "ubiq-1",
          "cluster" => {
            "id" => 1,
            "name" => "Los Angeles",
            "subdomain" => "la",
          },
        },
        {
          "ip_string" => "125.125.125.125",
          "domain_string" => "la.domain.com.",
          "friendly_name" => "ubiq-2",
          "cluster" => {
            "id" => 1,
            "name" => "Los Angeles",
            "subdomain" => "la",
          },
        }
      )
    end
  end
  describe "PUT /hosted_servers" do
    it "add a server to rotation" do
      put "/api/v1/hosted_servers/4"
      expect(response).to have_http_status(:success)

      get "/api/v1/hosted_servers"
      expect(response).to have_http_status(:success)

      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(4)
      expect(json_response).to contain_exactly(
        {
          "ip_string" => "5.5.5.5",
          "domain_string" => "eyz.domain.com.",
        },
        {
          "ip_string" => "123.123.123.123",
          "domain_string" => "la.domain.com.",
          "friendly_name" => "ubiq-1",
          "cluster" => {
            "id" => 1,
            "name" => "Los Angeles",
            "subdomain" => "la",
          },
        },
        {
          "ip_string" => "125.125.125.125",
          "domain_string" => "la.domain.com.",
          "friendly_name" => "ubiq-2",
          "cluster" => {
            "id" => 1,
            "name" => "Los Angeles",
            "subdomain" => "la",
          },
        },
        {
          "ip_string" => "234.234.234.234",
          "domain_string" => "hongkong.domain.com.",
          "friendly_name" => "rackspace-1",
          "cluster" => {
            "id" => 4,
            "name" => "Hong Kong",
            "subdomain" => "hongkong",
          },
        },
      )
    end
  end
  describe "DELETE /hosted_servers" do
    it "remove a server from rotation" do
      delete "/api/v1/hosted_servers/4"
      expect(response).to have_http_status(:success)

      get "/api/v1/hosted_servers"
      expect(response).to have_http_status(:success)

      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(3)
      expect(json_response).to contain_exactly(
        {
          "ip_string" => "5.5.5.5",
          "domain_string" => "eyz.domain.com.",
        },
        {
          "ip_string" => "123.123.123.123",
          "domain_string" => "la.domain.com.",
          "friendly_name" => "ubiq-1",
          "cluster" => {
            "id" => 1,
            "name" => "Los Angeles",
            "subdomain" => "la",
          },
        },
        {
          "ip_string" => "125.125.125.125",
          "domain_string" => "la.domain.com.",
          "friendly_name" => "ubiq-2",
          "cluster" => {
            "id" => 1,
            "name" => "Los Angeles",
            "subdomain" => "la",
          },
        },
      )
    end
  end

  describe "PUT /hosted_servers x 2" do
    it "add two server with different ip into same subdomain" do
      put "/api/v1/hosted_servers/4"
      expect(response).to have_http_status(:success)

      put "/api/v1/hosted_servers/5"
      expect(response).to have_http_status(:success)

      get "/api/v1/hosted_servers"
      expect(response).to have_http_status(:success)

      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(5)
      expect(json_response).to contain_exactly(
        {
          "ip_string" => "5.5.5.5",
          "domain_string" => "eyz.domain.com.",
        },
        {
          "ip_string" => "123.123.123.123",
          "domain_string" => "la.domain.com.",
          "friendly_name" => "ubiq-1",
          "cluster" => {
            "id" => 1,
            "name" => "Los Angeles",
            "subdomain" => "la",
          },
        },
        {
          "ip_string" => "125.125.125.125",
          "domain_string" => "la.domain.com.",
          "friendly_name" => "ubiq-2",
          "cluster" => {
            "id" => 1,
            "name" => "Los Angeles",
            "subdomain" => "la",
          },
        },
        {
          "ip_string" => "234.234.234.234",
          "domain_string" => "hongkong.domain.com.",
          "friendly_name" => "rackspace-1",
          "cluster" => {
            "id" => 4,
            "name" => "Hong Kong",
            "subdomain" => "hongkong",
          },
        },
        {
          "ip_string" => "235.235.235.235",
          "domain_string" => "hongkong.domain.com.",
          "friendly_name" => "rackspace-2",
          "cluster" => {
            "id" => 4,
            "name" => "Hong Kong",
            "subdomain" => "hongkong",
          },
        },
      )
    end
  end

  describe "DELETE /hosted_servers x 2" do
    it "remove two server with different ip from the same subdomain" do
      delete "/api/v1/hosted_servers/4"
      expect(response).to have_http_status(:success)

      get "/api/v1/hosted_servers"
      expect(response).to have_http_status(:success)

      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(4)
      expect(json_response).to contain_exactly(
        {
          "ip_string" => "5.5.5.5",
          "domain_string" => "eyz.domain.com.",
        },
        {
          "ip_string" => "123.123.123.123",
          "domain_string" => "la.domain.com.",
          "friendly_name" => "ubiq-1",
          "cluster" => {
            "id" => 1,
            "name" => "Los Angeles",
            "subdomain" => "la",
          },
        },
        {
          "ip_string" => "125.125.125.125",
          "domain_string" => "la.domain.com.",
          "friendly_name" => "ubiq-2",
          "cluster" => {
            "id" => 1,
            "name" => "Los Angeles",
            "subdomain" => "la",
          },
        },
        {
          "ip_string" => "235.235.235.235",
          "domain_string" => "hongkong.domain.com.",
          "friendly_name" => "rackspace-2",
          "cluster" => {
            "id" => 4,
            "name" => "Hong Kong",
            "subdomain" => "hongkong",
          },
        },
      )

      delete "/api/v1/hosted_servers/5"
      expect(response).to have_http_status(:success)

      get "/api/v1/hosted_servers"
      expect(response).to have_http_status(:success)

      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(3)
      expect(json_response).to contain_exactly(
        {
          "ip_string" => "5.5.5.5",
          "domain_string" => "eyz.domain.com.",
        },
        {
          "ip_string" => "123.123.123.123",
          "domain_string" => "la.domain.com.",
          "friendly_name" => "ubiq-1",
          "cluster" => {
            "id" => 1,
            "name" => "Los Angeles",
            "subdomain" => "la",
          },
        },
        {
          "ip_string" => "125.125.125.125",
          "domain_string" => "la.domain.com.",
          "friendly_name" => "ubiq-2",
          "cluster" => {
            "id" => 1,
            "name" => "Los Angeles",
            "subdomain" => "la",
          },
        },
      )
    end
  end

  describe "PUT /hosted_servers x 2" do
    it "add two server with same ip into different subdomain" do
      put "/api/v1/hosted_servers/3"
      expect(response).to have_http_status(:success)

      put "/api/v1/hosted_servers/6"
      expect(response).to have_http_status(:success)

      get "/api/v1/hosted_servers"
      expect(response).to have_http_status(:success)

      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(5)
      expect(json_response).to contain_exactly(
        {
          "ip_string" => "5.5.5.5",
          "domain_string" => "eyz.domain.com.",
        },
        {
          "ip_string" => "123.123.123.123",
          "domain_string" => "la.domain.com.",
          "friendly_name" => "ubiq-1",
          "cluster" => {
            "id" => 1,
            "name" => "Los Angeles",
            "subdomain" => "la",
          },
        },
        {
          "ip_string" => "125.125.125.125",
          "domain_string" => "la.domain.com.",
          "friendly_name" => "ubiq-2",
          "cluster" => {
            "id" => 1,
            "name" => "Los Angeles",
            "subdomain" => "la",
          },
        },
        {
          "ip_string" => "12.12.12.12",
          "domain_string" => "fra.domain.com.",
          "friendly_name" => "leaseweb-de-1",
          "cluster" => {
            "id" => 3,
            "name" => "Frankfurt",
            "subdomain" => "fra",
          },
        },
        {
          "ip_string" => "12.12.12.12",
          "domain_string" => "hongkong.domain.com.",
          "friendly_name" => "example-1",
          "cluster" => {
            "id" => 4,
            "name" => "Hong Kong",
            "subdomain" => "hongkong",
          },
        },
      )
    end
  end

  describe "DELETE /hosted_servers x 2" do
    it "remove two server with same ip from different subdomain" do
      delete "/api/v1/hosted_servers/3"
      expect(response).to have_http_status(:success)

      get "/api/v1/hosted_servers"
      expect(response).to have_http_status(:success)

      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(4)
      expect(json_response).to contain_exactly(
        {
          "ip_string" => "5.5.5.5",
          "domain_string" => "eyz.domain.com.",
        },
        {
          "ip_string" => "123.123.123.123",
          "domain_string" => "la.domain.com.",
          "friendly_name" => "ubiq-1",
          "cluster" => {
            "id" => 1,
            "name" => "Los Angeles",
            "subdomain" => "la",
          },
        },
        {
          "ip_string" => "125.125.125.125",
          "domain_string" => "la.domain.com.",
          "friendly_name" => "ubiq-2",
          "cluster" => {
            "id" => 1,
            "name" => "Los Angeles",
            "subdomain" => "la",
          },
        },
        {
          "ip_string" => "12.12.12.12",
          "domain_string" => "hongkong.domain.com.",
          "friendly_name" => "example-1",
          "cluster" => {
            "id" => 4,
            "name" => "Hong Kong",
            "subdomain" => "hongkong",
          },
        },
      )

      delete "/api/v1/hosted_servers/6"
      expect(response).to have_http_status(:success)

      get "/api/v1/hosted_servers"
      expect(response).to have_http_status(:success)

      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(3)
      expect(json_response).to contain_exactly(
        {
          "ip_string" => "5.5.5.5",
          "domain_string" => "eyz.domain.com.",
        },
        {
          "ip_string" => "123.123.123.123",
          "domain_string" => "la.domain.com.",
          "friendly_name" => "ubiq-1",
          "cluster" => {
            "id" => 1,
            "name" => "Los Angeles",
            "subdomain" => "la",
          },
        },
        {
          "ip_string" => "125.125.125.125",
          "domain_string" => "la.domain.com.",
          "friendly_name" => "ubiq-2",
          "cluster" => {
            "id" => 1,
            "name" => "Los Angeles",
            "subdomain" => "la",
          },
        },
      )
    end
  end
end
