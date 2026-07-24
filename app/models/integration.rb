class Integration < ApplicationRecord
  belongs_to :account

  validates :source_type, presence: true, inclusion: { in: -> { IntegrationEntry::Registry.available_sources } }
  validates :source_type, uniqueness: { scope: :account_id }
end
