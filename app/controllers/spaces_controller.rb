class SpacesController < ApplicationController
  def index
    @user = current_user
    if request.xhr?
      #only prints spaces where capacity is greater than quantity specified by user in form field
      @spaces = Space.where("capacity >=? ", params[:quantity])
      @spaces.near([params[:latitude], params[:logitude]])
      #save quantity passed into form field
      @quantity = params[:quantity]
      # puts params
      render partial: 'spaces'
    else
      #if no nearby spaces, print all spaces
      @spaces = Space.all
    end
  end

  def new
    @user = current_user
    @space = Space.new
    @quantity = params[:quantity]
  end

  def create
    @user = current_user
    @space = Space.new(space_params)
    # @count = current_user.spaces.count
    # @spaces = Space.all
    #user_id in spaces table is id of current user
    @space.user_id = params[:user_id]
    respond_to do |format|
      if @space.save
        format.js
      else
        format.js
      end
    end
  end

  def update
    @space = Space.find(params[:id])
    @space.capacity = params[:space][:capacity].to_i
    @space.update_attributes(space_params);
      if @space.save
        #format.js
        redirect_to user_path(current_user)
      else
        format.html { render :new }
        format.json { render json: @space.errors, status: :unprocessable_entity }
        format.js
      end
  end

  def show
    @user = User.find(params[:user_id])
    @space = @user.spaces.find(params[:id])
    render layout: false
  end

  def destroy
    @space = Space.find(params[:id])
    @space.destroy
    respond_to do |format|
      format.js {render inline: "location.reload();" }

    end
  end

  private
  def space_params
    params.require(:space).permit(:capacity, :address, :garbaje_day, :user_id)
  end
end
