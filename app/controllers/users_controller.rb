class UsersController < ApplicationController
  def create
    a = User.new
    a.email = params[:email]
    a.username = params[:name]
    a.password = params[:password]

    salt = "#{Time.now.to_i + Random.new.rand}"
    secret = "#{salt}#{a.id}"
    a.auth_token = Digest::MD5.hexdigest secret
    a.save!

    render :json => {"user_id" => a.id,
                     "email" => a.email,
                     "name" => a.username,
                     "auth_token" => a.auth_token,
                     'pic' => 'https://pp.userapi.com/c837427/v837427976/139fb/QEKQiag5mak.jpg'
                    }
  end


  def login
    if !(params[:token].blank?)
      a = User.where(:auth_token => params[:token]).first
      if a.blank?
        render :json => {'Error' => 'No user with this token'}, status: :not_found
      end
      render :json => {'auth_token' => a.auth_token}, status: :ok



    else
      if !(params[:email].blank?) && !(params[:password].blank?)
        a = User.where(:email => params[:email]).first
        if a.valid_password?(params[:password])
          render :json => {"user_id" => a.id,
                           "email" => a.email,
                           "name" => a.username,
                           "auth_token" => a.auth_token,
                           'pic' => 'https://pp.userapi.com/c837427/v837427976/139fb/QEKQiag5mak.jpg'
          }
        else
          render :json => {'Error' => 'Password incorrect'}, status: :forbidden
        end
      else
        render :json => {'Error' => 'Password or login are blank!'}, status: :forbidden
      end
    end
  end


  # def login
  #   a = User.where(:email => params[:email]).first
  #   if a.valid_password?(params[:password])
  #     render :json => {"user_id" => a.id,
  #                      "email" => a.email,
  #                      "name" => a.username,
  #                      "auth_token" => "thisistokenlol123",
  #                      'pic' => 'https://pp.userapi.com/c837427/v837427976/139fb/QEKQiag5mak.jpg'
  #     }
  #   else
  #     render :json => {'Error' => 'Something went wrong!'}, status: 500
  #   end
  # end

  def logout

  end

  def change_password

  end

  def gen_token

  end


end
