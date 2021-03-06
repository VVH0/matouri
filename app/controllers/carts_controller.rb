class CartsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :cart_not_found
  before_action :set_cart, only: [:show, :edit, :update, :destroy]

  # GET /carts
  # GET /carts.json
  def index
    @carts = Cart.all
  end

  # GET /carts/1
  # GET /carts/1.json
  def show
    if @cart.id == session[:cart_id]
    else redirect_to root_path, notice: 'Vous ne pouvez pas avoir accès aux paniers des autres utilisateurs.'
    end
  end

  # GET /carts/new
  def new
    @cart = Cart.new
  end

  # GET /carts/1/edit
  def edit
  end

  # POST /carts
  # POST /carts.json
  def create
    @cart = Cart.new(cart_params)

    respond_to do |format|
      if @cart.save
        format.html { redirect_to @cart, notice: 'Votre panier a bien été crée.' }
        format.json { render :show, status: :created, location: @cart }
      else
        format.html { render :new }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /carts/1
  # PATCH/PUT /carts/1.json
  def update
    respond_to do |format|
      if @cart.update(cart_params)
        format.html { redirect_to @cart, notice: 'Votre panier a été mis à jour.' }
        format.json { render :show, status: :ok, location: @cart }
      else
        format.html { render :edit }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carts/1
  # DELETE /carts/1.json
  def destroy
    return unless @cart.id == session[:cart_id]

    @cart.destroy
    session.delete(:cart_id)

    respond_to do |format|
      format.html { redirect_to root_path, notice: ('Le panier a bien été vidé') }
      format.json { head :no_content }
    end
  end

  private

  def cart_not_found
    redirect_to root_url, alert: t("Le panier n'existe pas")
  end
    # Use callbacks to share common setup or constraints between actions.
    def set_cart
      puts "set_cart"
      @cart = Cart.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cart_params
      params.fetch(:cart, {})
    end
end
