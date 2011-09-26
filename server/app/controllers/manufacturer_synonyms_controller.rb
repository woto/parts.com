class ManufacturerSynonymsController < ApplicationController
  # GET /manufacturer_synonyms
  # GET /manufacturer_synonyms.json
  def index
    @manufacturer_synonyms = ManufacturerSynonym.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @manufacturer_synonyms }
    end
  end

  # GET /manufacturer_synonyms/1
  # GET /manufacturer_synonyms/1.json
  def show
    @manufacturer_synonym = ManufacturerSynonym.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @manufacturer_synonym }
    end
  end

  # GET /manufacturer_synonyms/new
  # GET /manufacturer_synonyms/new.json
  def new
    @manufacturer_synonym = ManufacturerSynonym.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @manufacturer_synonym }
    end
  end

  # GET /manufacturer_synonyms/1/edit
  def edit
    @manufacturer_synonym = ManufacturerSynonym.find(params[:id])
  end

  # POST /manufacturer_synonyms
  # POST /manufacturer_synonyms.json
  def create
    @manufacturer_synonym = ManufacturerSynonym.new(params[:manufacturer_synonym])

    respond_to do |format|
      if @manufacturer_synonym.save
        format.html { redirect_to @manufacturer_synonym, :notice => 'Manufacturer synonym was successfully created.' }
        format.json { render :json => @manufacturer_synonym, :status => :created, :location => @manufacturer_synonym }
      else
        format.html { render :action => "new" }
        format.json { render :json => @manufacturer_synonym.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /manufacturer_synonyms/1
  # PUT /manufacturer_synonyms/1.json
  def update
    @manufacturer_synonym = ManufacturerSynonym.find(params[:id])

    respond_to do |format|
      if @manufacturer_synonym.update_attributes(params[:manufacturer_synonym])
        format.html { redirect_to @manufacturer_synonym, :notice => 'Manufacturer synonym was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @manufacturer_synonym.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /manufacturer_synonyms/1
  # DELETE /manufacturer_synonyms/1.json
  def destroy
    @manufacturer_synonym = ManufacturerSynonym.find(params[:id])
    @manufacturer_synonym.destroy

    respond_to do |format|
      format.html { redirect_to manufacturer_synonyms_url }
      format.json { head :ok }
    end
  end
end
