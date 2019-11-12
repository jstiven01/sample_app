require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "Invalid signup information" do
    get signup_path
    #assert_select 'form[action="/signup"]'

    assert_no_difference 'User.count' do
      post signup_path, params: { user:{ name: 'Johan Tinjaca',
                                        email: 'user@invalid',
                                        password: 'foo',
                                        password_confirmation: 'bar' }}
    end

    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
    assert_select 'div#error_explanation>ul>li:first-child', "Email is invalid"
    assert_select 'div#error_explanation>ul>li:nth-child(2)', "Password confirmation doesn't match Password"
    assert_select 'div#error_explanation>ul>li:last-child', "Password is too short (minimum is 6 characters)"
  end

  test "Valid signup information" do
    get signup_path
    #assert_select 'form[action="/signup"]'
    assert_difference 'User.count', 1 do
      post signup_path, params: { user:{name: 'Liset Restrepo',
                                  email: 'lisetrpo@gmail.com',
                                  password: '111111',
                                  password_confirmation: '111111' }}
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert is_logged_in?
  end
end
