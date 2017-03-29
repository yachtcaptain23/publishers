# LegalFormAddendums are created via API. See Api::Publishers #create_legal_form_addendum
class LegalFormAddendumsController < ApplicationController
  before_action :authenticate_publisher!
  before_action :require_verified_publisher
  before_action :require_legal_form
  before_action :require_incomplete_addendum

  # FIXME
  # layout "headless", only: %i(after_sign)

  # Sign or view signed form. Embedded Docusign.
  def show
  end

  def edit
  end

  def update
    # Addendum #fields set in Api::Publishers #create_legal_form_addendum
    field_data = params.require(:legal_form_addendum).permit(@addendum.normalized_fields)
    setter = LegalFormAddendumSetter.new(addendum: @addendum, field_data: field_data)
    if setter.validate_fields
      setter.perform
      redirect_to(home_publishers_path, notice: I18n.t("legal_form_addendums.saved"))
    else
      flash.now[:alert] = I18n.t("legal_form_addendums.field_data_invalid")
      render(:edit)
    end
  end

  private

  def require_legal_form
    if current_publisher && params[:publisher_legal_form_id] && params[:publisher_legal_form_id] == current_publisher.legal_form&.id
      @legal_form = current_publisher.legal_form
    end
    return if @legal_form
    redirect_to(home_publishers_path, alert: I18n.t("publisher_legal_forms.existing_required"))
  end

  # Complete once.
  def require_incomplete_addendum
    @addendum = @legal_form.addendums.where(id: params[:id]).first
    return if !@addendum.completed?
    redirect_to(home_publishers_path, alert: I18n.t("legal_form_addendums.incomplete_required"))
  end

  def require_verified_publisher
    return if current_publisher.verified?
    redirect_to(root_path, alert: I18n.t("publishers.verification_required"))
  end
end
