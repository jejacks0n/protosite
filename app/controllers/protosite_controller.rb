class ProtositeController < Protosite.configuration.parent_controller.constantize
  skip_before_action :verify_authenticity_token

  rescue_from GraphQL::ExecutionError, with: :handle_error

  def execute
    render json: Protosite::Schema.execute(params, current_user: current_user, channel: nil)
  end

  private

    def handle_error(e, status = 500, data = {})
      errors = e.respond_to?(:to_h) ? e.to_h : { message: e.message }
      render json: { data: data, errors: errors }, status: status
    end

    def current_user
      @current_user ||= begin
        user = Protosite::User.find_by(id: cookies.signed["protosite_user.id"])
        unless approved_dev_request?
          user ||= request.env["warden"].authenticate!
          cookies.signed["protosite_user.id"] = user.id
          user
        end
      end
    end

    def approved_dev_request?
      Rails.env.development? && params[:query] =~ /^\s+query IntrospectionQuery/
    end
end
