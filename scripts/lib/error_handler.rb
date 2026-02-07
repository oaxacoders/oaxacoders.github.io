# frozen_string_literal: true

module ErrorHandler
  def self.safe(logger, service_name)
    yield
  rescue StandardError => e
    logger.error("#{service_name} failed: #{e.message}")
    logger.error(e.backtrace&.first(5)&.join("\n"))
    nil
  end
end
