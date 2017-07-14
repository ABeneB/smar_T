require 'rails_helper'
require 'algorithm/variants/savingsplusplus'

RSpec.describe "SavingsPlusPlus Heuristic" do

  def order_in_tour?(tour, order)
    for order_tour in tour.order_tours do
      return true if order_tour.order == order
    end
    false
  end


  context "initialisation phase" do
    let!(:company) { FactoryGirl.create(:company)}
    let!(:depot) { FactoryGirl.create(:depot, company: company, address: company.address) }
    let!(:user) { FactoryGirl.create(:user_driver, password: "password", company: company)}
    let!(:customer_1) { FactoryGirl.create(:customer, company: company) }
    let!(:customer_2) { FactoryGirl.create(:customer, company: company) }
    let!(:order_1) { FactoryGirl.create(:delivery_order, customer: customer_1) }
    let!(:order_2) { FactoryGirl.create(:delivery_order, customer: customer_2, start_time: nil) }
    let!(:driver) { FactoryGirl.create(:active_driver, user: user) }
    let!(:vehicle) { FactoryGirl.create(:vehicle, driver: driver, position: company.address) }
    let(:day_tours) {
      savingsplusplus = Algorithm::Variants::SavingsPlusPlus.new(company)
      savingsplusplus.init(company.orders.to_a, company.drivers.to_a)
    }

    it "builds return trivial tour for every due order" do
      expect(day_tours.count()).to eq(2)
      for tour in day_tours do
        expect(tour.order_tours.count).to eq(5)
      end
    end

    it "builds day tours containing orders in right sequence" do
      expect(order_in_tour?(day_tours[0], order_1)).to be(true)
      expect(order_in_tour?(day_tours[1], order_2)).to be(true)
    end

    it "builds trivial tours with duration greater than 0" do
      for tour in day_tours do
        expect(tour.duration).to be > 0
      end
    end
  end
end
