#
# TODO: Clean up routing.
#

Rails.application.routes.draw do
  resources :global_wiki_templates, except: [:edit]
end
