require 'redmine'

Redmine::Plugin.register :redmine_auto_change_start_status do
  name 'Auto Change Start Status'
  author 'Roman Shipiev'
  description 'Changing start status issue from default to status from plugin settings'
  version '0.0.1'
  url 'https://bitbucket.org/rubynovich/redmine_auto_change_start_status'
  author_url 'http://roman.shipiev.me'

  settings :default => {
                         :issue_status => IssueStatus.default.id
                       },
           :partial => 'settings/settings'
end

if Rails::VERSION::MAJOR < 3
  require 'dispatcher'
  object_to_prepare = Dispatcher
else
  object_to_prepare = Rails.configuration
end

object_to_prepare.to_prepare do
  [:issue].each do |cl|
    require "acss_#{cl}_patch"
  end

  [
    [Issue, AutoChangeStartStatusPlugin::IssuePatch]
  ].each do |cl, patch|
    cl.send(:include, patch) unless cl.included_modules.include? patch
  end
end
