# frozen_string_literal: true

# noinspection RubocopInspection
class GlobalWikiTemplatesController < ApplicationController
  layout 'base'
  helper :wiki
  include WikiTemplatesHelper
  include Concerns::WikiTemplatesCommon
  menu_item :wikis
  before_action :find_object, only: %i[show edit update destroy]
  before_action :find_project, only: %i[edit update]
  before_action :require_admin, only: %i[index new show], excep: [:preview]

  #
  # Action for global template : Admin right is required.
  #
  def index
    template_map = GlobalWikiTemplate.all
    render layout: !request.xhr?, locals: { template_map: template_map }
  end

  def new
    # create empty instance
    @global_wiki_template = GlobalWikiTemplate.new
    render render_form_params
  end

  def create
    @global_wiki_template = GlobalWikiTemplate.new
    @global_wiki_template.author = User.current

    begin
      @global_wiki_template.safe_attributes = valid_params
    rescue ActiveRecord::SerializationTypeMismatch, Concerns::WikiTemplatesCommon::InvalidTemplateFormatError
      flash[:error] = I18n.t(:builtin_fields_should_be_valid_json, default: 'Please enter a valid JSON fotmat string.')
      render render_form_params.merge(action: :new)
      return
    end
    save_and_flash(:notice_successful_create, :new) && return
  end

  def show
    render render_form_params
  end

  def update
    begin
      @global_wiki_template.safe_attributes = valid_params
    rescue ActiveRecord::SerializationTypeMismatch, Concerns::WikiTemplatesCommon::InvalidTemplateFormatError
      flash[:error] = I18n.t(:builtin_fields_should_be_valid_json, default: 'Please enter a valid JSON fotmat string.')
      render render_form_params.merge(action: :show)
      return
    end

    save_and_flash(:notice_successful_update, :show)
  end

  def edit
    # Change from request.post to request.patch for Rails4.
    return unless request.patch? || request.put?

    begin
      @global_wiki_template.safe_attributes = valid_params
    rescue ActiveRecord::SerializationTypeMismatch
      flash[:error] = I18n.t(:builtin_fields_should_be_valid_json, default: 'Please enter a valid JSON fotmat string.')
      render render_form_params.merge(action: :show)
      return
    end

    save_and_flash(:notice_successful_update, :show)
  end

  def destroy
    unless @global_wiki_template.destroy
      flash[:error] = l(:enabled_template_cannot_destroy)
      redirect_to action: :show, id: @global_wiki_template
      return
    end

    flash[:notice] = l(:notice_successful_delete)
    redirect_to action: 'index'
  end

  # preview
  def preview
    global_wiki_template = params[:global_wiki_template]
    id = params[:id]
    @text = (global_wiki_template ? global_wiki_template[:description] : nil)
    @global_wiki_template = GlobalWikiTemplate.find(id) if id
    render partial: 'common/preview'
  end

  private

  def orphaned
    GlobalWikiTemplate.orphaned
  end

  def find_project
    @projects = Project.all
  end

  def find_object
    @global_wiki_template = GlobalWikiTemplate.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def save_and_flash(message, action_on_failure)
    unless @global_wiki_template.save
      render render_form_params.merge(action: action_on_failure)
      return
    end

    respond_to do |format|
      format.html do
        flash[:notice] = l(message)
        redirect_to action: 'show', id: @global_wiki_template.id
      end
      format.js { head 200 }
    end
  end

  def template_params
    params.require(:global_wiki_template)
          .permit(:title, :wiki_title, :description, :note, :is_default, :enabled,
                  :author_id, :position, :related_link, :link_title, :builtin_fields,
                  project_ids: [], checklists: [])
  end

  def render_form_params
    projects = Project.all

    { layout: !request.xhr?,
      locals: { checklist_enabled: checklist_enabled?, apply_all_projects: apply_all_projects?,
                wiki_template: @global_wiki_template, projects: projects,
                builtin_fields_enable: builtin_fields_enabled? } }
  end
end
