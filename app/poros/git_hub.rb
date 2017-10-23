# frozen_string_literal: true

NUMBER_OF_DEVS = 4.0
NUMBER_OF_WORK_DAYS_PER_WEEK = 5.0

Octokit.auto_paginate = true

class GitHub
  attr_reader :client
  def initialize
    @client = Octokit::Client.new(
      access_token: ENV.fetch("GITHUB_ACCESS_TOKEN"),
    )
    client.user.login
  end

  def org_events
    @org_events ||= client.organization_events(ENV.fetch("GITHUB_ORG_NAME"))
  end

  def push_events
    @push_events ||= org_events.select! { |event| event.type == "PushEvent" }
  end

  def pushes_by_day
    pushes_by_day = {}

    push_events.each do |event|
      key = event.created_at.strftime("%m/%d/%Y")

      if pushes_by_day[key]
        pushes_by_day[key] << event
      else
        pushes_by_day[key] = [] << event
      end
    end

    pushes_by_day
  end

  def pushes_by_week
    pushed_by_week = {}

    push_events.each do |event|
      key = event.created_at.beginning_of_week.strftime("%m/%d/%Y")

      if pushed_by_week[key]
        pushed_by_week[key] << event
      else
        pushed_by_week[key] = [] << event
      end
    end

    pushed_by_week
  end

  def averages_per_day
    averages_per_day = {}

    pushes_by_day.each do |k, v|
      averages_per_day[k] = v.length / NUMBER_OF_DEVS
    end

    averages_per_day
  end

  def averages_per_week
    averages_per_week = {}

    pushes_by_week.each do |k, v|
      averages_per_week[k] = v.length / NUMBER_OF_WORK_DAYS_PER_WEEK
    end

    averages_per_week
  end
end
