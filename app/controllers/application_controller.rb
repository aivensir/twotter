class ApplicationController < ActionController::API
  #before_action :authenticate_user!
  #before_action :masquerade_user!

  #protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
end
