require 'digest/md5'

module IntegrationProcessable
  extend ActiveSupport::Concern

  included do
    def initialize(payload, account:)
      @payload = payload.is_a?(Hash) ? payload.with_indifferent_access : payload
      @account = account
    end

    def process
      import_adapter.import_transaction(
        external_id: external_id,
        amount: amount,
        currency: currency,
        date: date,
        name: name,
        source: source_name,
        merchant: merchant,
        notes: notes,
        extra: extra_metadata
      )
    end
  end

  private

    attr_reader :payload, :account

    def import_adapter
      @import_adapter ||= Account::ProviderImportAdapter.new(account)
    end

    def currency
      account.currency
    end

    def merchant
      merchant_name = payload[:merchant]&.strip
      return nil unless merchant_name.present?

      import_adapter.find_or_create_merchant(
        provider_merchant_id: "instant_alert_#{Digest::MD5.hexdigest(merchant_name.downcase)}",
        name: merchant_name,
        source: source_name
      )
    end

    def notes
      nil
    end

    def extra_metadata
      nil
    end
end
