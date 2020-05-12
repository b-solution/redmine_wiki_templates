# frozen_string_literal: true

class GlobalWikiTemplate < ActiveRecord::Base
  include Redmine::SafeAttributes
  include Concerns::WikiTemplate::Common
  validates_presence_of :title
  has_and_belongs_to_many :projects

  safe_attributes 'title',
                  'description',
                  'note',
                  'enabled',
                  'is_default',
                  'wiki_title',
                  'project_ids',
                  'position',
                  'author_id',
                  'checklist_json',
                  'related_link',
                  'link_title',
                  'builtin_fields_json'

  # for intermediate table assosciations
  scope :search_by_project, lambda { |project_id|
    joins(:projects).where(projects: { id: project_id }) if project_id.present?
  }

  module Config
    JSON_OBJECT_NAME = 'global_wiki_template'
  end
  Config.freeze


  #
  # Class method
  #
  class << self
    def get_templates_for_project(project_id)
      GlobalWikiTemplate.search_by_project(project_id)
                         .enabled
                         .sorted
    end
  end
end
