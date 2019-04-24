namespace :employer do
  desc 'Migrate existing data to the new Tesco employer'
  task migrate: :environment do
    ActiveRecord::Base.transaction do
      return puts 'Skipping!' if Employer.find_by(name: 'Tesco')

      @employer = Employer.create!(name: 'Tesco')

      Location.update_all(employer_id: @employer.id) # rubocop:disable SkipsModelValidations

      DeliveryCentre.find_each do |dc|
        Assignment.find_or_create_by!(
          employer: @employer,
          delivery_centre: dc
        )
      end
    end
  end
end
