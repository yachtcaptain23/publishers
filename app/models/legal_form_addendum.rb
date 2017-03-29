# frozen_string_literal: true
class LegalFormAddendum < ApplicationRecord
  attr_encrypted :s3_key, key: :encryption_key
  has_paper_trail
  belongs_to :publisher_legal_form
  has_one :publisher, through: :publisher_legal_form
  delegate :brave_publisher_id, :email, :name, to: :publisher
  validates :publisher_legal_form_id, presence: true
  validates :fields, array: true, presence: true
  before_create :generate_addendum_number

  def completed?
    s3_key.present?
  end

  def encryption_key
    Rails.application.secrets[:attr_encrypted_key]
  end

  def normalized_fields
    fields.map(&:to_s)
  end

  private

  def generate_addendum_number
    self.addendum_number = publisher_legal_form.addendums.count
  end
end
