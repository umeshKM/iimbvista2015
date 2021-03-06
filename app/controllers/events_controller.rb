class EventsController < ApplicationController
  # GET /events
  # GET /events.json

  before_filter :check_permission

  def check_permission
     authorize! :manage, Event
  end

  def index
    if current_user.is_super_admin?
      @events = Event.unscoped.all
    else
      @events = current_user.event_categories.collect{|ec| ec.events}
      @events=@events.flatten.compact
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.unscoped.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    if current_user.is_super_admin?
      @event_cats=EventCategory.unscoped.all
    else
      @event_cats=current_user.event_categories
    end
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/edit
  def edit    
    if current_user.is_super_admin?
      @event_cats=EventCategory.unscoped.all
    else
      @event_cats=current_user.event_categories
    end
    @event = Event.unscoped.find(params[:id])
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.unscoped.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.unscoped.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end

  def for_event_category
    @event_category_id = params[:id]
    @events=Event.unscoped.where(event_category_id: @event_category_id )
    render :template => "/events/index"
  end

  def my_events
    @event_category_id = current_user.event_categories.collect(&:id)
    @events=Event.unscoped.where(event_category_id: @event_category_id )
    render :template => "/events/index"
  end

end
