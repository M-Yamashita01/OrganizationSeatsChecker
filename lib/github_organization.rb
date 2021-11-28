# frozen_string_literal: true

require 'octokit'
require_relative 'logging'

class GitHubOrganization
  include Logging

  def initialize(access_token:, organization_name:)
    @access_token = access_token
    @organization_name = organization_name
  end

  def seats
    client = Octokit::Client.new(access_token: @access_token)
    organization = client.org(@organization_name)
    org_plan = organization[:plan]
    filled_seats = org_plan[:filled_seats]
    max_seats = org_plan[:seats]

    {
      filled_seats: filled_seats,
      max_seats: max_seats
    }
  rescue StandardError => e
    logger.error(e.message)
    logger.error(e.backtrace.join("\n"))
    raise e
  end
end
