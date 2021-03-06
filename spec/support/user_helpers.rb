module UserHelpers
  def with_real_sso
    sso_env = ENV['GDS_SSO_MOCK_INVALID']
    ENV['GDS_SSO_MOCK_INVALID'] = '1'

    yield
  ensure
    ENV['GDS_SSO_MOCK_INVALID'] = sso_env
  end

  def given_the_user_has_no_permissions
    @user = create(:orphaned_user)
    GDS::SSO.test_user = @user

    yield
  ensure
    GDS::SSO.test_user = nil
  end

  def given_the_user_is_identified_as_an_api_user
    @user = create(:api_user)
    GDS::SSO.test_user = @user

    yield
  ensure
    GDS::SSO.test_user = nil
  end

  def given_the_user_is_identified_as_an_administrator
    @user = create(:administrator)
    GDS::SSO.test_user = @user

    yield
  ensure
    GDS::SSO.test_user = nil
  end

  def given_the_user_is_identified_as_a_booking_manager(opts = {})
    @user = create(:booking_manager, opts)
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

  def appointment_for_user(user, **opts)
    start_at = opts.delete(:start_at) || Time.current
    opts[:created_at] ||= 1.day.ago

    build(:appointment, opts) do |a|
      a.slot = build(
        :slot,
        start_at: start_at,
        room: user.location.rooms.first
      )

      a.save!
    end
  end

  def slot_for_user(user, start_at: Time.current.advance(days: 1))
    create(
      :slot,
      start_at: start_at,
      room: user.location.rooms.first
    )
  end
end
