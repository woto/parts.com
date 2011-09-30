class ProcessingController < ApplicationController
  def new
    @processing = Processing.new(
      :fields => 10, 
      :datetime => DateTime.now, 
      :processes => 10,
      :sleeping => 20
    )
  end

  def create
    @processing = Processing.new(params[:processing])

    respond_to do |format|
      if @processing.save
        #format.html { render :text => result }
        format.html { redirect_to '/', :notice => 'Processing was successfully created.' }
      else
        format.html { render :action => "new" }
      end
    end
  end

end
