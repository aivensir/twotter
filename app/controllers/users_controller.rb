class UsersController < ApplicationController

  def create
    a = User.new
    a.email = params[:email].downcase
    a.username = params[:name]
    a.password = params[:password]
    a.save!

    salt = "#{Time.now.to_i + Random.new.rand}"
    secret = "#{salt}#{a.id}"
    a.auth_token = Digest::MD5.hexdigest secret
    a.auth_token_created_at = Time.now.to_s
    a.save!

    render :json => {'user_id' => a.id,
                     'email' => a.email,
                     'name' => a.username,
                     'auth_token' => a.auth_token,
                     'pic' => 'https://pp.userapi.com/c837427/v837427976/139fb/QEKQiag5mak.jpg'
                    }, status: :ok
    return
  end


  def token_auth
    a = User.where(:auth_token => params[:auth_token]).first
    if a.blank?
      render :json => {'error' => 'No user with this token.'}, status: :not_found
      return
    end

    if Time.now - a.auth_token_created_at > 30.days
      a.auth_token = ""
      a.save!
      render :json => {'error' => 'Session timeout.'}, status: :forbidden
      return
    end

    render :json => {'user_id' => a.id,
                     'email' => a.email,
                     'name' => a.username,
                     'auth_token' => a.auth_token,
                     'pic' => 'https://pp.userapi.com/c837427/v837427976/139fb/QEKQiag5mak.jpg'
    }, status: :ok
    return
  end

  def login
      if !(params[:email].blank?) && !(params[:password].blank?)
        a = User.where(:email => params[:email].downcase).first
        if a.blank?
          render :json => {'error' => 'No user with this email.'}, status: :not_found
          return
        end

        if a.valid_password?(params[:password])
          if a.auth_token.blank?
            salt = "#{Time.now.to_i + Random.new.rand}"
            secret = "#{salt}#{a.id}"
            a.auth_token = Digest::MD5.hexdigest secret
            a.auth_token_created_at = Time.now.to_s
            a.save!
          end
          render :json => {'user_id' => a.id,
                           'email' => a.email,
                           'name' => a.username,
                           'auth_token' => a.auth_token,
                           'pic' => 'https://pp.userapi.com/c837427/v837427976/139fb/QEKQiag5mak.jpg'
          }, status: :ok
        else
          render :json => {'error' => 'Password incorrect'}, status: :forbidden
        end
      else
        render :json => {'error' => 'Password or login are blank!'}, status: :forbidden
      end
  end

 def logout
    a = User.where(:auth_token => params[:auth_token]).last
    if a.blank?
      render :json => {'error' => 'No user with this token.'}, status: :not_found
      return
    end
    a.auth_token = ""
    a.save!
    render :json => {}, status: :ok
  end

  def change_password
    a = User.find_by auth_token: params[:auth_token]
    if a.blank?
      render :json => {'Error!' => 'No user with this token!'}, status: :not_found
      return
    end
    if a.valid_password?(params[:password])
      a.password = params[:new_password]
      a.save!
      render :json => {'user_id' => a.id,
                       'email' => a.email,
                       'name' => a.username,
                       'auth_token' => a.auth_token,
                       'pic' => 'https://pp.userapi.com/c837427/v837427976/139fb/QEKQiag5mak.jpg'
      }, status: :ok
    else
      render :json => {'Error!' => 'Invalid password'}, status: :forbidden
    end
  end


<<<<<<< HEAD
=======
  def reset_password

  end
>>>>>>> upstream/dev
end
