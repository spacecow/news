Feature:

Scenario: Sign up
When I go to the signup page
And I fill in "Name" with "Ben Dover"
And I fill in "Username" with "dover"
And I fill in "Email" with "king@the.wd"
And I fill in "Affiliation" with "King of the world"
And I fill in "Password" with "foobar"
And I fill in "Password confirmation" with "foobar"
And I press "Sign up"
Then I should see "Thank you for signing up! You are now logged in." as notice flash message
And a user should exist with name: "Ben Dover", username: "dover", email: "king@the.wd", affiliation: "King of the world"
And 1 users should exist
And I should be on the root page
