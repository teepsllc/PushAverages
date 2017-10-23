class AveragesController < ApplicationController
  def index
    github = GitHub.new

    render json: { daily: github.averages_per_day, weekly: github.averages_per_week }
  end
end
