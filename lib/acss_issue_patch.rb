require_dependency 'issue'

module AutoChangeStartStatusPlugin
  module IssuePatch
    def self.included(base)
      base.extend(ClassMethods)
      
      base.send(:include, InstanceMethods)
      
      base.class_eval do
        after_create :change_status, :if => "self.author == self.assigned_to"
      end

    end
      
    module ClassMethods

    end
    
    module InstanceMethods
      def change_status
        if self.status == IssueStatus.default
          begin
            self.status = IssueStatus.find(Setting[:plugin_redmine_auto_change_start_status][:issue_status])
            self.save
          rescue
          end
        end
      end
    end
  end
end
