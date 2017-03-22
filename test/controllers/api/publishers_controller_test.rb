require "test_helper"
require "shared/mailer_test_helper"

class Api::PublishersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include ActionMailer::TestHelper
  include MailerTestHelper
  include PublishersHelper

  PUBLISHER_PARAMS = {
    publisher: {
      email: "alice@example.com",
      brave_publisher_id: "pyramid.net",
      name: "Alice the Pyramid",
      phone: "+14159001420"
    }
  }.freeze

  test "can create legal form addendums" do
    legal_form = publisher_legal_forms(:completed)
    publisher = legal_form.publisher
    path = create_legal_form_addendum_api_publishers_path(brave_publisher_id: publisher.brave_publisher_id)
    params = { fields: ["addressCountry", "flightSpeedUnladenSwallow"] }
    assert_difference("LegalFormAddendum.count") do
      post(path, params: params)
      assert_response(201)
    end
    addendum = LegalFormAddendum.order(created_at: :asc).last
    assert_equal(addendum.publisher_legal_form, legal_form)
    assert_equal(addendum.publisher, publisher)
  end

  test "can't create legal form addendums without params" do
    legal_form = publisher_legal_forms(:completed)
    publisher = legal_form.publisher
    post(create_legal_form_addendum_api_publishers_path(brave_publisher_id: publisher.brave_publisher_id))
    assert_response(400)
  end
end
