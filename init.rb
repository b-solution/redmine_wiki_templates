# frozen_string_literal: true

# Redmine Issue Template Plugin
#
# This is a plugin for Redmine to generate and use issue templates
# for each project to assist issue creation.
# Created by Akiko Takano.
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.

require 'redmine'


Redmine::Plugin.register :redmine_wiki_templates do
    name 'Redmine Issue Templates plugin'
    author 'Bilel'
    description 'Plugin to generate and use wiki templates for each project to assist issue creation.'
    version '1.0.0'
    author_url 'http://www.github.com/bilel-kedidi'
    requires_redmine version_or_higher: '4.0'


    settings default: {
                 apply_global_template_to_all_projects: 'false',
                 apply_template_when_edit_issue: 'false',
                 enable_builtin_fields: 'false'
             }#, partial: 'settings/redmine_wiki_templates'


    menu :admin_menu, :redmine_wiki_templates, { controller: 'global_wiki_templates', action: 'index' },
         caption: :global_wiki_templates, html: { class: 'icon icon-global_issue_templates' }

end
