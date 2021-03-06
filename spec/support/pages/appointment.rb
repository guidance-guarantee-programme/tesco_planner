module Pages
  class Appointment < SitePrism::Page
    set_url '/appointments/{id}/edit'

    element :message, '.t-message'
    element :submit_message, '.t-submit-message'
    elements :activities, '.t-activity'

    element :first_name, '.t-first-name'
    element :last_name, '.t-last-name'
    element :email, '.t-email'
    element :phone, '.t-phone'
    element :memorable_word, '.t-memorable-word'
    element :status, '.t-status'
    element :day_of_birth, '.t-date-of-birth-day'
    element :month_of_birth, '.t-date-of-birth-month'
    element :year_of_birth, '.t-date-of-birth-year'
    element :dc_pot_confirmed_yes, '.t-dc-pot-confirmed-yes'
    element :dc_pot_confirmed_dont_know, '.t-dc-pot-confirmed-dont-know'
    element :gdpr_consent_yes, '.t-gdpr-consent-yes'
    element :gdpr_consent_no, '.t-gdpr-consent-no'
    element :gdpr_consent_no_response, '.t-gdpr-consent-no-response'

    element :submit, '.t-submit'

    element :errors, '.t-errors'
  end
end
