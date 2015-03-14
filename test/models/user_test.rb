require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
  	@user = User.new(name: "Test name", email: "test@email.com", password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
  	@user.name = "  "
  	assert_not @user.valid?
  end

  test "email should be present" do
  	@user.email = " "
  	assert_not @user.valid?
  end

  test "name should not be too long" do
  	@user.name = "a" * 51
  	assert_not @user.valid?
  end

  test "email should not be too long" do
  	@user.email = "a" * 244 + "@example.com"
  	assert_not @user.valid?
  end

  test "email address should be unique" do
  	duplicate_user = @user.dup
  	duplicate_user.email = @user.email.upcase
  	@user.save
  	assert_not duplicate_user.valid?
  end

  test "email validation should reject invalid addresses" do
  	invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated projects should be destroyed" do
    @user.save
    @user.projects.create!(name: "Some", description: "bla bla")
    assert_difference 'Project.count', -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    lana = User.new(name: "Lana", email: "l@a.com", password: "foobar")
    lana.save
    archer = User.new(name: "Archer", email: "a@a.com", password: "foobar")
    archer.save
    assert_not lana.following?(archer)
    lana.follow(archer)
    assert lana.following?(archer)
    assert archer.followers.include?(lana)
    lana.unfollow(archer)
    assert_not lana.following?(archer)
  end

end
