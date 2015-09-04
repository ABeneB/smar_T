require 'test_helper'

class OrderToursControllerTest < ActionController::TestCase
  setup do
    @order_tour = order_tours(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:order_tours)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create order_tour" do
    assert_difference('OrderTour.count') do
      post :create, order_tour: { company_id: @order_tour.company_id, location: @order_tour.location, order_id: @order_tour.order_id, place: @order_tour.place, tour_id: @order_tour.tour_id, user_id: @order_tour.user_id }
    end

    assert_redirected_to order_tour_path(assigns(:order_tour))
  end

  test "should show order_tour" do
    get :show, id: @order_tour
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @order_tour
    assert_response :success
  end

  test "should update order_tour" do
    patch :update, id: @order_tour, order_tour: { company_id: @order_tour.company_id, location: @order_tour.location, order_id: @order_tour.order_id, place: @order_tour.place, tour_id: @order_tour.tour_id, user_id: @order_tour.user_id }
    assert_redirected_to order_tour_path(assigns(:order_tour))
  end

  test "should destroy order_tour" do
    assert_difference('OrderTour.count', -1) do
      delete :destroy, id: @order_tour
    end

    assert_redirected_to order_tours_path
  end
end
