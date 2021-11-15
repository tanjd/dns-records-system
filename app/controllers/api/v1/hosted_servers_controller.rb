class Api::V1::HostedServersController < ApplicationController
  before_action :set_hosted_server, only: [:show]
  before_action :set_server, only: [:update, :destroy]

  # GET /hosted_servers
  def index
    @hosted_servers = []
    servers = []
    hosted_servers = HostedServer.get_hosted_servers_from_aws()

    servers = Server.where(ip_string: hosted_servers.keys.map { |row| row[0] })

    servers.each do |server|
      domain_string = server.get_domain_string()
      if hosted_servers.include?([server.ip_string, domain_string])
        hosted_servers[[server.ip_string, domain_string]][:friendly_name] = server.friendly_name
        hosted_servers[[server.ip_string, domain_string]][:cluster_id] = server.cluster_id
      end
    end

    hosted_servers.each do |key_array, record_details|
      if record_details.key?(:cluster_id)
        cluster = Cluster.find_by_id(record_details[:cluster_id])
        hosted_server = {
          :ip_string => key_array[0],
          :domain_string => key_array[1],
          :friendly_name => record_details[:friendly_name],
          :cluster => {
            :id => cluster.id,
            :name => cluster.name,
            :subdomain => cluster.subdomain,
          },
        }
      else
        hosted_server = {
          :ip_string => key_array[0],
          :domain_string => key_array[1],
        }
      end

      @hosted_servers << hosted_server
    end

    render json: @hosted_servers
  end

  # POST /hosted_servers
  def create
    @hosted_server = HostedServer.new(hosted_server_params)

    if @hosted_server.save
      render json: @hosted_server, status: :created, location: @hosted_server
    else
      render json: @hosted_server.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /hosted_servers/1
  def update
    if HostedServer.add_to_rotation(@server)
      render json: ({ :message => "successfully added to rotation" }), status: 200
    else
      render json: ({ :message => "unsuccessfully added to rotation" }), status: 400
    end
  end

  # DELETE /hosted_servers/1
  def destroy
    if HostedServer.remove_from_rotation(@server)
      render json: ({ :message => "successfully removed from rotation" }), status: 200
    else
      render json: ({ :message => "unsuccessfully removed from rotation" }), status: 400
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_hosted_server
    @hosted_server = HostedServer.find(params[:id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_server
    @server = Server.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def hosted_server_params
    params.require(:hosted_server).permit(:ip_string, :domain_string)
  end
end
