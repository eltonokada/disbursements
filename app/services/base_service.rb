# frozen_string_literal: true

# app/services/base_service.rb
class BaseService
  def self.call(*args, &block)
    new(*args, &block).call
  end
end
