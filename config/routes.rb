# frozen_string_literal: true

Rails.application.routes.draw do
  get "averages", to: "averages#index"
end
