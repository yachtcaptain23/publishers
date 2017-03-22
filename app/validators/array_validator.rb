class ArrayValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if !value.is_a?(Array)
      record.errors[attribute] << (options[:message] || "must be an array")
    end
  end
end
