require 'test_helper'

class ChoferesControllerTest < ActionController::TestCase
  setup do
    @chofer = choferes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:choferes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create chofer" do
    assert_difference('Chofer.count') do
      post :create, chofer: { apodo: @chofer.apodo, estado: @chofer.estado, fechaestado: @chofer.fechaestado, nombre: @chofer.nombre }
    end

    assert_redirected_to chofer_path(assigns(:chofer))
  end

  test "should show chofer" do
    get :show, id: @chofer
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @chofer
    assert_response :success
  end

  test "should update chofer" do
    patch :update, id: @chofer, chofer: { apodo: @chofer.apodo, estado: @chofer.estado, fechaestado: @chofer.fechaestado, nombre: @chofer.nombre }
    assert_redirected_to chofer_path(assigns(:chofer))
  end

  test "should destroy chofer" do
    assert_difference('Chofer.count', -1) do
      delete :destroy, id: @chofer
    end

    assert_redirected_to choferes_path
  end
end
