class ShippingLabelsController < ApplicationController
  # GET /shipping_labels
  # GET /shipping_labels.json
  def index
    @shipping_labels = ShippingLabel.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @shipping_labels }
    end
  end

  # GET /shipping_labels/1
  # GET /shipping_labels/1.json
  def show
    @shipping_label = ShippingLabel.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @shipping_label }
    end
  end

  # GET /shipping_labels/new
  # GET /shipping_labels/new.json
  def new
    @shipping_label = ShippingLabel.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @shipping_label }
    end
  end

  # GET /shipping_labels/1/edit
  def edit
    @shipping_label = ShippingLabel.find(params[:id])
  end

  # POST /shipping_labels
  # POST /shipping_labels.json
  def create
    @shipping_info = params
    binding.pry
    @shipping_label = ShippingLabel.new(params[:shipping_label])

    respond_to do |format|
      if @shipping_label.save
        format.html { redirect_to @shipping_label, notice: 'Shipping label was successfully created.' }
        format.json { render json: @shipping_label, status: :created, location: @shipping_label }
      else
        format.html { render action: "new" }
        format.json { render json: @shipping_label.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /shipping_labels/1
  # PUT /shipping_labels/1.json
  def update
    @shipping_label = ShippingLabel.find(params[:id])

    respond_to do |format|
      if @shipping_label.update_attributes(params[:shipping_label])
        format.html { redirect_to @shipping_label, notice: 'Shipping label was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @shipping_label.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shipping_labels/1
  # DELETE /shipping_labels/1.json
  def destroy
    @shipping_label = ShippingLabel.find(params[:id])
    @shipping_label.destroy

    respond_to do |format|
      format.html { redirect_to shipping_labels_url }
      format.json { head :no_content }
    end
  end
end
