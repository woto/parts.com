class ProcessingController < ApplicationController
  def new
    @processing = Processing.new(:fields => 10, :datetime => DateTime.now - 1.day)
  end

  def create
    @processing = Processing.new(params[:processing])

    respond_to do |format|
      if result = @processing.save
        format.html { render :text => result }
        # format.html { redirect_to '/', :notice => 'Part was successfully created.' }
      else
        format.html { render :action => "new" }
      end
    end
  end

end
