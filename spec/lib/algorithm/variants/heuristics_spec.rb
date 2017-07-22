require 'rails_helper'
require 'algorithm/variants/heuristic'

RSpec.describe "Heuristic Base class" do
  let!(:company) { FactoryGirl.create(:company) }
  let!(:depot) { FactoryGirl.create(:depot, company: company, address: company.address) }
  let!(:restriction) { FactoryGirl.create(:regular_dp_restriction, company: company) }
  let!(:user) { FactoryGirl.create(:user_driver, password: "password", company: company) }
  let!(:driver) { FactoryGirl.create(:active_driver, user: user) }
  let!(:vehicle) { FactoryGirl.create(:vehicle, driver: driver, position: company.address) }
  let!(:tour) { Tour.create(driver: driver) }
  let!(:customer) { FactoryGirl.create(:customer) }
  let!(:order) { FactoryGirl.create(:delivery_order, customer: customer) }
  let!(:vehicle_pos) { OrderTour.create(tour: tour, place: 0, kind: "vehicle_position") }
  let!(:depot) { OrderTour.create(tour: tour, place: 1, kind: "depot") }
  let!(:home_1) { OrderTour.create(tour: tour, place: 2, kind: "home") }
  let!(:order_tour) { OrderTour.create(tour: tour, order: order, place: 3, kind: "delivery") }
  let!(:home_2) { OrderTour.create(tour: tour, place: 4, kind: "home") }
  let!(:heuristic) { Algorithm::Variants::Heuristic.new(company) }

  before { allow(heuristic).to receive(:time_for_distance).and_return(10) }

  context "#check_restriction" do
    context "with tour matching all restrictions" do
      before { heuristic.update_capacity(tour) }

      it "returns true" do
        expect(heuristic.check_restriction(tour.order_tours, driver)).to be(true)
      end
    end

    context "with tour violating capacity restriction" do
      before do
        order.capacity = 101
        order.save
        heuristic.update_capacity(tour)
      end

      it "returns false" do
        expect(heuristic.check_restriction(tour.order_tours, driver)).to eq(false)
      end
    end

    context "with tour violating time window" do
      before do
        order.end_time = DateTime.now - 5.minutes
        order.save
      end

      it "returns false" do
        expect(heuristic.check_restriction(tour.order_tours, driver)).to eq(false)
      end
    end

    context "with tour violating working time" do
      before do
        order.update_attribute(:duration_delivery, 480)
        heuristic.update_order_tour_times(tour.order_tours)
        tour.duration = heuristic.calc_tour_duration(tour)
      end

      it "returns false" do
        expect(heuristic.check_restriction(tour.order_tours, driver)).to eq(false)
      end
    end
  end

  context "#calc_tour_duration" do
    before { heuristic.update_order_tour_times(tour.order_tours) }

    it "return the duration of the complete tour" do
      expect(heuristic.calc_tour_duration(tour)).to eq(60)
    end
  end
end
