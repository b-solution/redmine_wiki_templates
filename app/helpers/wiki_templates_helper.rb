module WikiTemplatesHelper
  def project_tracker?(tracker, project)
    return false unless tracker.present?

    project.trackers.exists?(tracker.id)
  end

  def non_project_tracker_msg(flag)
    return '' if flag

    "<font class=\"non_project_tracker\">#{l(:unused_tracker_at_this_project)}</font>".html_safe
  end


  def options_for_template_pulldown(options)
    options.map do |option|
      text = option.try(:name).to_s
      tag_builder.content_tag_string(:option, text, option, true)
    end.join("\n").html_safe
  end
end
