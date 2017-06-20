require 'rails_helper'
require 'algorithm/variants/savingsplusplus'

RSpec.describe "SavingsPlusPlus Heuristic" do

  context "initialisation phase" do
      let!(:company) { FactoryGirl.create(:company)}
      let!(:depot) { FactoryGirl.create(:depot, company_id: company.id, address: company.address) }
      let!(:user) { FactoryGirl.create(:user_driver, password: "password", company_id: company.id)}
      let!(:customer) { FactoryGirl.create(:customer, company_id: company.id) }
      let!(:order) { FactoryGirl.create(:delivery_order, customer_id: customer.id) }
      let!(:driver) { FactoryGirl.create(:driver, user_id: user.id) }
      let!(:vehicle) { FactoryGirl.create(:vehicle, driver_id: driver.id, position: company.address) }

    it "should return one trivial tours" do
      savingsplusplus = Algorithm::Variants::SavingsPlusPlus.new(company)
      expect(savingsplusplus.init(company.orders.to_a, company.drivers.to_a).count()).to eq(1)
    end
  end
end
