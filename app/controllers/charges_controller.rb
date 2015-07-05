require 'ecomm/amount'

class ChargesController < ApplicationController

  def new
    @stripe_btn_data = {
      key: "#{ Rails.configuration.stripe[:publishable_key] }",
      description: "Private Wiki Membership - #{current_user.email}",
      amount: Amount.default
    }
  end

    def create
      customer = Stripe::Customer.create(
        email: current_user.email,
        card: params[:stripeToken]
      )

      charge = Stripe::Charge.create(
        customer: customer.id,
        amount: Amount.default,
        description: "Private Wiki Membership - #{current_user.email}",
        currency: "cad"
      )

      flash[:success] = "Thank you for your order! We have sent a confirmation to your email address."
      redirect_to edit_user_registration_path

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to new_charge_path
    end
end
