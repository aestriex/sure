class Api::V1::IntegrationEventsController < Api::V1::BaseController
  before_action :ensure_write_scope

  def create
    account = current_resource_owner.family.accounts.find(params[:account_id])

    processor_class = IntegrationEntry::Registry.processor_for(params[:source_type])
    return render_json({ error: "Unknown source_type: #{params[:source_type]}" }, status: :unprocessable_entity) unless processor_class

    entry = processor_class.new(event_params, account: account).process
    render_json({ status: "ok", entry_id: entry.id }, status: :created)
  rescue => e
    Rails.logger.error "IntegrationEventsController - #{e.class}: #{e.message}"
    render_json({ error: "Failed to process event" }, status: :unprocessable_entity)
  end

  private

    def ensure_write_scope
      authorize_scope!(:write)
    end

    def event_params
      params.permit(:raw_text, :amount, :merchant, :received_at)
    end
end
