module UserHelpers
  def with_real_sso
    sso_env = ENV['GDS_SSO_MOCK_INVALID']
    ENV['GDS_SSO_MOCK_INVALID'] = '1'

    yield
  ensure
    ENV['GDS_SSO_MOCK_INVALID'] = sso_env
  end

  def given_the_user_is_identified_as_an_administrator
    @user = create(:administrator)
    GDS::SSO.test_user = @user

    yield
  ensure
    GDS::SSO.test_user = nil
  end

  def given_the_user_is_identified_as_a_booking_manager(type: :booking_manager)
    @user = create(type)
    GDS::SSO.test_user = @user

    yield
  ensure
    GDS::SSO.test_user = nil
  end

  def given_the_user_is_identified_as_an_unassigned_booking_manager
    @user = create(:unassigned_booking_manager)
    GDS::SSO.test_user = @user

    yield
  ensure
    GDS::SSO.test_user = nil
  end

  def given_the_user_is_identified_as_a_guider
    @user = create(:guider)
    GDS::SSO.test_user = @user

    yield
  ensure
    GDS::SSO.test_user = nil
  end

  def appointment_for_user(user, start_at: Time.current)
    build(:appointment) do |a|
      a.slot = build(
        :slot,
        start_at: start_at,
        delivery_centre: user.delivery_centre,
        room: user.location.rooms.first
      )

      a.save!
    end
  end

  def slot_for_user(user, start_at: Time.current.advance(days: 1))
    create(
      :slot,
      start_at: start_at,
      delivery_centre: user.delivery_centre,
      room: user.location.rooms.first
    )
  end
end
