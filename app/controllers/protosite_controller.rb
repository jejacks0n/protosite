class ProtositeController < Protosite.configuration.parent_controller.constantize
  skip_before_action :verify_authenticity_token

  rescue_from GraphQL::ExecutionError, with: :handle_error

  def app
    @page = Protosite::Page.new
  end

  def execute
    render json: Protosite::Schema.execute(params, current_user: current_user, channel: nil)
  end

  def login
    request.env["warden"].authenticate!
    redirect_to "/"
  end

  def logout
    request.env["warden"].logout
    redirect_to "/", status: 401
  end

  private

    def handle_error(e, status = 500, data = {})
      errors = e.respond_to?(:to_h) ? e.to_h : { message: e.message }
      render json: { data: data, errors: errors }, status: status
    end
end
