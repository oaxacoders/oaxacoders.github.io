# frozen_string_literal: true

require "logger"

module OaxacodersLogger
  def self.create(name)
    logger = Logger.new($stdout)
    logger.progname = name
    logger.formatter = proc do |severity, _datetime, progname, msg|
      "[#{progname}] #{severity}: #{msg}\n"
    end
    logger
  end
end
