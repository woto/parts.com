require 'test_helper'

class ManufacturerSynonymsControllerTest < ActionController::TestCase
  setup do
    @manufacturer_synonym = manufacturer_synonyms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manufacturer_synonyms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manufacturer_synonym" do
    assert_difference('ManufacturerSynonym.count') do
      post :create, :manufacturer_synonym => @manufacturer_synonym.attributes
    end

    assert_redirected_to manufacturer_synonym_path(assigns(:manufacturer_synonym))
  end

  test "should show manufacturer_synonym" do
    get :show, :id => @manufacturer_synonym.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @manufacturer_synonym.to_param
    assert_response :success
  end

  test "should update manufacturer_synonym" do
    put :update, :id => @manufacturer_synonym.to_param, :manufacturer_synonym => @manufacturer_synonym.attributes
    assert_redirected_to manufacturer_synonym_path(assigns(:manufacturer_synonym))
  end

  test "should destroy manufacturer_synonym" do
    assert_difference('ManufacturerSynonym.count', -1) do
      delete :destroy, :id => @manufacturer_synonym.to_param
    end

    assert_redirected_to manufacturer_synonyms_path
  end
end
