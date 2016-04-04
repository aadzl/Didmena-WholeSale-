class SessionsController < ApplicationController

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      if current_user.apps_manager
        redirect_to users_path
      else
        redirect_to models_path
      end
    else
      flash.now[:alert] = "Log in failed...Try again."
    end
  end

  def destroy
    session[:user_id] = nil
    session[:cart] = nil
    redirect_to root_path
  end

end