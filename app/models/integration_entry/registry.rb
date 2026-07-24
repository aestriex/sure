module IntegrationEntry
  class Registry
    PROCESSORS = {
      "sms" => "SmsAlertEntry::Processor"
      # "google_wallet" => "GoogleWalletEntry::Processor",
      # "paypal"        => "PaypalEntry::Processor"
    }.freeze

    def self.processor_for(source_type)
      klass_name = PROCESSORS[source_type]
      return nil unless klass_name

      klass_name.constantize
    end

    def self.available_sources
      PROCESSORS.keys
    end
  end
end
