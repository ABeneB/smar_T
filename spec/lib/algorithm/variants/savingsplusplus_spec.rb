require 'rails_helper'
require 'algorithm/variants/savingsplusplus'

RSpec.describe "SavingsPlusPlus Heuristic" do

  context "initialisation phase" do
      let!(:company) { FactoryGirl.create(:company)}
      let!(:depot) { FactoryGirl.create(:depot, company: company, address: company.address) }
      let!(:user) { FactoryGirl.create(:user_driver, password: "password", company: company)}
      let!(:customer) { FactoryGirl.create(:customer, company: company) }
      let!(:order) { FactoryGirl.create(:delivery_order, customer: customer) }
      let!(:driver) { FactoryGirl.create(:active_driver, user: user) }
      let!(:vehicle) { FactoryGirl.create(:vehicle, driver: driver, position: company.address) }
      let(:day_tours) {
        savingsplusplus = Algorithm::Variants::SavingsPlusPlus.new(company)
        savingsplusplus.init(company.orders.to_a, company.drivers.to_a)
      }

    it "builds return one trivial" do
      expect(day_tours.count()).to eq(1)
    end

    it "builds trivial tour with duration greater than 0" do
      expect(day_tours[0].duration).to be > 0
    end
  end
end
