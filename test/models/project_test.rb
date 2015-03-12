require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  def setup
  	@user = User.new(name: "Dude", email: "dude@aides.com")
  	@project = @user.projects.build(name: "First project", description: "Lorem ipsum")
  end

  test "should be valid" do
  	#assert @project.valid?
  end

  test "user id should be present" do
  	@project.user_id = nil
  	assert_not @project.valid?
  end

  test "description should be present" do
  	@project.description = "  "
  	assert_not @project.valid?
  end

  test "order should be most recent first" do
  	assert_equal Project.first, projects(:most_recent)
  end

end
