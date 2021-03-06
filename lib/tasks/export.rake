namespace :export do # rubocop:disable BlockLength
  QUERIES = {
    'MAPS_PWBLZ_TESCOAPPOINT_' => 'id, status, type_of_appointment, gdpr_consent, slot_id, created_at, updated_at',
    'MAPS_PWBLZ_TESCODLVCEN_'  => 'id, name, created_at, updated_at',
    'MAPS_PWBLZ_TESCOEMPL_'    => 'id, name, created_at, updated_at',
    'MAPS_PWBLZ_TESCOLOC_'     => 'id, employer_id, delivery_centre_id, name, created_at, updated_at',
    'MAPS_PWBLZ_TESCORMS_'     => 'id, name, location_id, created_at, updated_at',
    'MAPS_PWBLZ_TESCOSLT_'     => 'id, room_id, start_at, end_at, created_at, updated_at'
  }.freeze

  desc 'Export CSV data to blob storage for analysis'
  task blob: :environment do
    export_to_azure_blob('MAPS_PWBLZ_TESCOAPPOINT_', Appointment)
    export_to_azure_blob('MAPS_PWBLZ_TESCODLVCEN_', DeliveryCentre)
    export_to_azure_blob('MAPS_PWBLZ_TESCOEMPL_', Employer)
    export_to_azure_blob('MAPS_PWBLZ_TESCOLOC_', Location)
    export_to_azure_blob('MAPS_PWBLZ_TESCORMS_', Room)
    export_to_azure_blob('MAPS_PWBLZ_TESCOSLT_', Slot)
  end

  desc 'Export status CSV data to blob storage for lookups'
  task statuses: :environment do
    rows = ['id,name']

    Appointment.statuses.each { |key, value| rows << "#{value},#{key}" }

    client = Azure::Storage::Blob::BlobService.create_from_connection_string(
      ENV.fetch('AZURE_CONNECTION_STRING')
    )

    client.create_block_blob(
      'pw-prd-data',
      "/To_Be_Processed/MAPS_PWBLZ_TESCOSTATUS_#{Time.current.strftime('%Y%m%d%H%M%S')}.csv",
      rows.join("\n")
    )
  end

  def export_to_azure_blob(key, model_class) # rubocop:disable MethodLength
    from_timestamp = ENV.fetch('FROM') { 3.months.ago }

    model_class.public_send(:acts_as_copy_target)

    data = model_class
           .where('created_at >= ? or updated_at >= ?', from_timestamp, from_timestamp)
           .select(QUERIES[key])
           .order(:created_at)
           .copy_to_string

    client = Azure::Storage::Blob::BlobService.create_from_connection_string(
      ENV.fetch('AZURE_CONNECTION_STRING')
    )

    client.create_block_blob(
      'pw-prd-data',
      "/To_Be_Processed/#{key}#{Time.current.strftime('%Y%m%d%H%M%S')}.csv",
      data
    )
  end
end
