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

  def export_to_azure_blob(key, model_class)
    model_class.public_send(:acts_as_copy_target)

    data = model_class.select(QUERIES[key]).order(:created_at).copy_to_string

    client = Azure::Storage::Blob::BlobService.create_from_connection_string(
      ENV.fetch('AZURE_CONNECTION_STRING')
    )

    client.create_block_blob(
      'pw-prd-data',
      "#{key}#{Time.current.strftime('%Y%m%d%H%M%S')}.csv",
      data
    )
  end
end
