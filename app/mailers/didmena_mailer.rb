class DidmenaMailer < ActionMailer::Base
<<<<<<< HEAD
  # default from: "aiste@aiste.ca"
  default from: "linas.uloza@gmail.com"
=======
  default from: "aiste.ulozaite@gmail.com"
>>>>>>> refs/remotes/origin/master

  # def first_email(user)
  #   @user = user
  #   mail(to: 'aiste@aiste.ca', subject: 'First Email')
  # end

  def order_confirmation(user, order)
    @user = user
    @order = order
    @purchases_for_order = Order.find(@order.id).purchases
    mail(to: @user.email, subject: 'Order confirmation.')
  end

end