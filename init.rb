require 'redmine'

Redmine::Plugin.register :redmine_auto_change_start_status do
  name 'Автосмена начального статуса'
  author 'Roman Shipiev'
  description 'Меняет статус задачи на заданный (в настройках) при создании задачи самому себе. Например, с "Новая" на "В работе". Нужен для особо забывчивых'
  version '0.0.1'
  url 'https://github.com/rubynovich/redmine_auto_change_start_status'
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
