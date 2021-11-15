class Api::V1::ServersController < ApplicationController
  before_action :set_server, only: [:show, :update, :destroy]

  # GET /servers
  def index
    @servers = Server.all

    hosted_servers = HostedServer.get_hosted_servers_from_aws()

    @servers.each do |server|
      domain_string = server.get_domain_string()
      if hosted_servers.include?([server.ip_string, domain_string])
        server.domain_string = domain_string
      end
    end

    render json: @servers
  end

  # GET /servers/1
  def show
    render json: @server
  end

  # POST /servers
  def create
    @server = Server.new(server_params)

    if @server.save
      render json: @server, status: :created, location: @server
    else
      render json: @server.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /servers/1
  def update
    if @server.update(server_params)
      render json: @server
    else
      render json: @server.errors, status: :unprocessable_entity
    end
  end

  # DELETE /servers/1
  def destroy
    @server.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_server
    @server = Server.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def server_params
    params.require(:server).permit(:friendly_name, :cluster_id, :ip_string)
  end
end
