class ProcessingController < ApplicationController
  def new
    @processing = Processing.new(:fields => 10)
  end

  def create
    @processing = Processing.new(params[:processing])

    respond_to do |format|
      if @processing.save
        format.html { redirect_to '/', :notice => 'Part was successfully created.' }
      else
        format.html { render :action => "new" }
      end
    end
  end

end
