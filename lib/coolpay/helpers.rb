# frozen_string_literal: true

module Coolpay
  #
  # Helper methods
  #
  module Helpers
    #
    # Check an API result and raise an exception if it contains errors.
    # Optionally, check the presence of a key in the result. Raise if key is not
    # found, and otherwise return the value of the key.
    #
    def check_api_result(
      api_result,
      description: '',
      expect_and_return_key: nil
    )
      errors = api_result[:errors]
      raise Coolpay::Error, "Error #{description}: #{errors.to_json}" if errors

      if expect_and_return_key
        key_value = api_result[expect_and_return_key]
        key_value || raise(
          Coolpay::Error,
          "Error #{description}: response missing #{expect_and_return_key}"
        )
      else
        api_result
      end
    end
  end
end
