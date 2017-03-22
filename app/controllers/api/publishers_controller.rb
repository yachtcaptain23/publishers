class Api::PublishersController < Api::BaseController
  before_action :require_verified_publisher,
    only: %i(notify update_legal_form create_legal_form_addendum)
  before_action :require_valid_legal_form,
    only: %i(create_legal_form_addendum update_legal_form)

  def notify
    PublisherNotifier.new(
      notification_params: params[:params],
      notification_type: params[:type],
      publisher: @publisher
    ).perform
    render(json: { message: "success" })
  rescue PublisherNotifier::InvalidNotificationTypeError => error
    render(json: { message: error.message }, status: 400)
  end

  def index_by_brave_publisher_id
    publishers = Publisher.where(
      brave_publisher_id: params[:brave_publisher_id]
    )
    render(json: publishers)
  end

  def update_legal_form
    # Only thing you can update currently
    if params[:brave_status] == "void"
      if @legal_form.void
        render(json: { message: "success" })
      else
        render(json: { message: "error" }, status: 400)
      end
    end
  end

  def create_legal_form_addendum
    addendum_params = { fields: params[:fields] }
    addendum = @legal_form.addendums.build(addendum_params)
    if addendum.save
      render(json: { message: "success" }, status: 201)
    else
      render(json: { message: "error", errors: addendum.errors.as_json }, status: 400)
    end
  end

  private

  def require_valid_legal_form
    @legal_form = @publisher.legal_form
    return @legal_form if @legal_form
    if @publisher.legal_forms.any?
      render(json: { message: "Publisher doesn't have a valid legal form. Did you already invalidate it?" }, status: 422)
    else
      render(json: { message: "Publisher doesn't have any legal forms." }, status: 404)
    end
  end

  def require_verified_publisher
    @publisher = Publisher.find_by(
      brave_publisher_id: params[:brave_publisher_id],
      verified: true
    )
    return @publisher if @publisher
    response = {
      error: "Invalid publisher",
      message: "Can't find a verified publisher with ID #{params[:brave_publisher_id]}"
    }
    render(json: response, status: 404)
  end
end
