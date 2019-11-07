require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "Login with invalid information" do
    get login_path #Visit the login path
    assert_template 'sessions/new' # Verify that the new sessions render properly
    post login_path, params: { session: { email: "", password: "" }} # Post to session path with an invalid params
    assert_template 'sessions/new' # The response view with Flash errors
    assert_not flash.empty? # with Flash errors
    get root_path
    assert flash.empty? # Flash empty when a different page is visited

  end

  test 'Login with valid information' do
    get login_path
    post login_path, params: { session: { email: @user.email, password: 'password'}}
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end

  test 'Login with valid information followd by logout' do
    get login_path
    post login_path, params: { session: { email: @user.email, password: 'password'}}
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
end
