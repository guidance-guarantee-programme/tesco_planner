module UserHelpers
  def given_the_user_is_identified_as_a_booking_manager
    @user = create(:booking_manager)
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
end
