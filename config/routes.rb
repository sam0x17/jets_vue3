# frozen_string_literal: true

Jets.application.routes.draw do
  root 'home#index'

  any '*catchall', to: 'home#handle_404'
end

RESOURCE_ROUTES = Jets.application.routes.routes.select { |item| item.instance_variable_get(:@scope).try(:from) == :resources }.to_set
