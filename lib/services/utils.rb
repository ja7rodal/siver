# frozen_string_literal: true

require 'json'

module Utils
  def parsed_json(response)
    JSON.parse(response.body, symbolize_names: true)
  end

  def acceptance_token_getter(response)
    json = parsed_json(response)
    json.dig(:data, :presigned_acceptance, :acceptance_token)
  end

  def transaction_data(response)
    data = parsed_json(response)[:data]
    {}.tap do |h|
      h[:transaction_id] = data[:id]
      h[:status] = status_mapped(data[:status].to_sym)
    end
  end

  def status_mapped(status)
    {
      PENDING: 1,
      APPROVED: 2,
      DECLINED: 3
    }[status]
  end

  def map_status(response)
    status = parsed_json(response)[:data][:status].to_sym
    status_mapped(status)
  end

  def pub_key
    ENV['PUB_KEY']
  end

  def parsed_error(response)
    json = parsed_json(response)
    json.merge(code: response.code)
  end

  def reference
    "#{('A'..'Z').to_a.sample(3).join}-#{Time.now.to_i}"
  end
end
