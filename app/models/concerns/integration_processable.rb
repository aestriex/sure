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

    def notes
      nil
    end

    def extra_metadata
      nil
    end
end
