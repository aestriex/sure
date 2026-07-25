require "digest/md5"

class SmsAlertEntry::Processor
  include IntegrationProcessable

  private

    def source_name
      "sms"
    end

    def external_id
      raw = "#{payload[:raw_text]}-#{payload[:received_at]}"
      "sms_alert_#{Digest::MD5.hexdigest(raw)}"
    end

    def amount
      BigDecimal(payload[:amount].to_s)
    end

    def date
      payload[:received_at].present? ? Time.zone.parse(payload[:received_at].to_s).to_date : Date.current
    end

    def name
      payload[:merchant].presence || "Card transaction"
    end

    def notes
      "Auto-created from instant SMS alert."
    end

    def extra_metadata
      { "sms_alert" => { "raw_text" => payload[:raw_text], "received_at" => payload[:received_at], "parsed_merchant" => payload[:merchant] } }
    end
end
