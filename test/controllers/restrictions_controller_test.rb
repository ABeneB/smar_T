require 'test_helper'

class RestrictionsControllerTest < ActionController::TestCase
  setup do
    @restriction = restrictions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:restrictions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create restriction" do
    assert_difference('Restriction.count') do
      post :create, restriction: { capacity_restriction: @restriction.capacity_restriction, company_id: @restriction.company_id, dynamic: @restriction.dynamic, multi_vehicle: @restriction.multi_vehicle, priorities: @restriction.priorities, problem: @restriction.problem, time_window: @restriction.time_window, user_id: @restriction.user_id, work_time: @restriction.work_time }
    end

    assert_redirected_to restriction_path(assigns(:restriction))
  end

  test "should show restriction" do
    get :show, id: @restriction
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @restriction
    assert_response :success
  end

  test "should update restriction" do
    patch :update, id: @restriction, restriction: { capacity_restriction: @restriction.capacity_restriction, company_id: @restriction.company_id, dynamic: @restriction.dynamic, multi_vehicle: @restriction.multi_vehicle, priorities: @restriction.priorities, problem: @restriction.problem, time_window: @restriction.time_window, user_id: @restriction.user_id, work_time: @restriction.work_time }
    assert_redirected_to restriction_path(assigns(:restriction))
  end

  test "should destroy restriction" do
    assert_difference('Restriction.count', -1) do
      delete :destroy, id: @restriction
    end

    assert_redirected_to restrictions_path
  end
end
