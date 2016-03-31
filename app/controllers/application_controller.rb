class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :set_locale

  helper_method :current_user
  helper_method :current_order

  def current_order
    if !session[:order_id].nil?
      Order.find(session[:order_id])
    else
      Order.new.save
    end
  end

  # def current_order
  #   if !session[:order_id].nil?
  #     logger.debug "not nil in current order"
  #     @current_order = Order.find(session[:order_id])
  #   else
  #     logger.debug "before order created"
  #     # @current_order = Order.find(3)
  #     @current_order = Order.create
  #     Order.find(session[:order_id])
  #     binding.pry
  #     logger.debug "after order created"
  #   end

  # end

  # def current_order
  #   binding.pry
  #   @current_order ||= Order.find(session[:order_id]) if session[:order_id]
  #   logger.debug "after checkign for current_order"
  # end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options = {})
    {locale: I18n.locale}
  end

  protected

  def restrict_access
    if !current_user
      flash[:alert] = "You must log in."
      redirect_to new_session_path
    end

  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

end
