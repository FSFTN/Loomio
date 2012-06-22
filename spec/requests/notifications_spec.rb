require 'spec_helper'

describe "Notifications" do
  subject { page }

  # TODO (spec):
  #
  # Given that I am a member of a group
  # And given that someone else has created a new discussion in the group
  # When I visit the dashboard
  # Then I should see a new notification on the notifications icon
  #
  # Given that I am a member of a group
  # And given that someone else has created a new discussion in the group
  # When I click on the notification icon
  # Then I should see a notice that a new discussion has been created in the group

  context "a logged in user, member of a group" do
    before :each do
      @user = User.make!
      @group = Group.make!(name: 'Test Group', viewable_by: :members)
      @group.add_member!(@user)
      page.driver.post user_session_path, 'user[email]' => @user.email,
                                          'user[password]' => 'password'
    end

    context "new discussion is created" do
      before { create_discussion(group: @group, author: @user) }

      it "should have a notification count of 1" do
        visit root_url
        find("#notification-count").should have_content("1")
      end
    end

    context "two new discussions are created" do
      before do
        create_discussion(group: @group, author: @user)
        create_discussion(group: @group, author: @user)
      end

      it "should have a notification count of 2" do
        visit root_url
        find("#notification-count").should have_content("2")
      end
    end
  end
end
