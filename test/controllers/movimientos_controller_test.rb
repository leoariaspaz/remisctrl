require 'test_helper'

class MovimientosControllerTest < ActionController::TestCase
  setup do
    @movimiento = movimientos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:movimientos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create movimiento" do
    assert_difference('Movimiento.count') do
      post :create, movimiento: { chofer_id: @movimiento.chofer_id, importe: @movimiento.importe, movil_id: @movimiento.movil_id, observacion: @movimiento.observacion, transaccion_id: @movimiento.transaccion_id }
    end

    assert_redirected_to movimiento_path(assigns(:movimiento))
  end

  test "should show movimiento" do
    get :show, id: @movimiento
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @movimiento
    assert_response :success
  end

  test "should update movimiento" do
    patch :update, id: @movimiento, movimiento: { chofer_id: @movimiento.chofer_id, importe: @movimiento.importe, movil_id: @movimiento.movil_id, observacion: @movimiento.observacion, transaccion_id: @movimiento.transaccion_id }
    assert_redirected_to movimiento_path(assigns(:movimiento))
  end

  test "should destroy movimiento" do
    assert_difference('Movimiento.count', -1) do
      delete :destroy, id: @movimiento
    end

    assert_redirected_to movimientos_path
  end
end
