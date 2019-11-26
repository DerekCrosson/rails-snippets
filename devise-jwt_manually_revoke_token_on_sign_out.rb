# When using Devise and Devise-JWT with the Blacklist revocation startegy, the tokens are issued but not revoked.
# Below is an example of doing this manually when overriding the Sessions Controller

class SessionsController < Devise::SessionsController
  skip_before_action :verify_signed_out_user
  respond_to :json
  
  def destroy
    # Revoke JWT and run default logout action.
    token = request.headers.env['HTTP_AUTHORIZATION'].to_s.split('Bearer ').last
    revoke_token(token)
    # Delete Authorization header
    request.delete_header('HTTP_AUTHORIZATION')
    super
  end
  
  private
    def revoke_token(token)
      # Decode JWT to get jti and exp values.
      secret = ENV['devise_secret_key']
      jti = JWT.decode(token, secret, true, algorithm: 'HS256', verify_jti: true)[0]['jti']
      exp = JWT.decode(token, secret, true, algorithm: 'HS256')[0]['exp']
      
      # Add record to blacklist.
      sql_blacklist_jwt = "INSERT INTO jwt_blacklists (jti, exp, created_at, updated_at) VALUES ('#{ jti }', '#{ Time.at(exp) }', now(), now());"
      ActiveRecord::Base.connection.execute(sql_blacklist_jwt)
    end
  
    def respond_with(resource, _opts = {})
      render json: resource
    end
  
    def respond_to_on_destroy
      head :ok
    end
end
