module Admin
  class LocationsController < ApplicationController
    before_action :authorise_administrator!

    def index
      @locations = Location.all.order(:name).page(params[:page])
    end
  end
end
