class ShippingRatesController < ApplicationController
  # GET /shipping_rates
  # GET /shipping_rates.json
  def index
    @shipping_rates = ShippingRate.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @shipping_rates }
    end
  end

  # GET /shipping_rates/1
  # GET /shipping_rates/1.json
  def show
    @shipping_rate = ShippingRate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @shipping_rate }
    end
  end

  # GET /shipping_rates/new
  # GET /shipping_rates/new.json
  def new
    @shipping_rate = ShippingRate.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @shipping_rate }
    end
  end

  # GET /shipping_rates/1/edit
  def edit
    @shipping_rate = ShippingRate.find(params[:id])
  end

  # POST /shipping_rates
  # POST /shipping_rates.json
  def create
    @shipping_rate = ShippingRate.new(params[:shipping_rate])

    respond_to do |format|
      if @shipping_rate.save
        format.html { redirect_to @shipping_rate, notice: 'Shipping rate was successfully created.' }
        format.json { render json: @shipping_rate, status: :created, location: @shipping_rate }
      else
        format.html { render action: "new" }
        format.json { render json: @shipping_rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /shipping_rates/1
  # PUT /shipping_rates/1.json
  def update
    @shipping_rate = ShippingRate.find(params[:id])

    respond_to do |format|
      if @shipping_rate.update_attributes(params[:shipping_rate])
        format.html { redirect_to @shipping_rate, notice: 'Shipping rate was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @shipping_rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shipping_rates/1
  # DELETE /shipping_rates/1.json
  def destroy
    @shipping_rate = ShippingRate.find(params[:id])
    @shipping_rate.destroy

    respond_to do |format|
      format.html { redirect_to shipping_rates_url }
      format.json { head :no_content }
    end
  end
end
