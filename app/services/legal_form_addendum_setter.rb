# Set LegalFormAddendum fields on S3.
class LegalFormAddendumSetter
  attr_reader :legal_form_addendum, :field_data

  # field_data: { 'key1' => 'value1', ... }
  def initialize(legal_form_addendum:, field_data:)
    @legal_form_addendum = legal_form_addendum
    @field_data = field_data
  end

  def perform
    #
  end

  def validate_fields
    return false if field_data.blank?
    legal_form_addendum.normalized_fields.all? do |field|
      field_data[field].present?
    end
  end

  private

  def base_s3_key
    @legal_form_addendum
  end
end
