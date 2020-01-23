module Admin
  class EmployersController < ApplicationController
    before_action :authorise_administrator!
    before_action :load_delivery_centres, except: :index

    def index
      @employers = Employer.order(:name).page(params[:page])
    end

    def new
      @employer = Employer.new
    end

    def create
      @employer = Employer.new(employer_params)

      if @employer.save
        CloudflareEmployerRedirectJob.perform_later(@employer)

        redirect_to admin_employers_path, success: 'The employer was created'
      else
        render :new
      end
    end

    private

    def load_delivery_centres
      @delivery_centres = DeliveryCentre.order(:name)
    end

    def employer_params
      params.require(:employer).permit(:name, :url, delivery_centre_ids: [])
    end
  end
end
