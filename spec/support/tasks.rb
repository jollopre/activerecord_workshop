require "rake"

module TaskFormat
  extend ActiveSupport::Concern
  included do
    let(:task_name) { self.class.top_level_description.sub(/\Arake /, "") }
    let(:tasks) { Rake::Task }
    subject(:task) { tasks[task_name] }
    after(:each) { task.reenable }
  end
end

RSpec.configure do |config|
  config.include TaskFormat, type: :task
end
