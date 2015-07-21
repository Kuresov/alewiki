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

      if current_user.role == "standard"
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
    
        current_user.update_attributes(role: "premium")
        flash[:success] = "Thank you for your order! We have sent a confirmation to your email address."
        redirect_to edit_user_registration_path
      else
        current_user.update_attributes(role: "standard") unless current_user.role == "admin"
        flash[:success] = "Account downgrade confirmed."
        redirect_to edit_user_registration_path
      end

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to new_charge_path
    end

  def downgrade

    current_user.update_attributes(role: "standard")

    current_user.wikis.each do |wiki|
      wiki.update_attributes(private: false)
    end

    redirect_to edit_user_registration_path
  end
end
