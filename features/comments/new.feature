Feature:

@anonymous @validate
Scenario: Validate an anonymous comment
When I go to the new comment page
And I fill in "Name" with "Ben Dover"
And I fill in "Email" with "king@the.wd"
And I fill in "Affiliation" with "King of the world"
And I fill in "Content" with "Rock on"
And I press "Create Comment"
Then I should see "Successfully created comment." as notice flash message
And I should be on the verify comments page
And I should see "Name: Ben Dover"
And I should see "Email: king@the.wd"
And I should see "Affiliation: King of the world"
And I should see "Content: Rock on"

@anonymous @create
Scenario: Create an anonymous comment
When I go to the new comment page
And I fill in "Name" with "Ben Dover"
And I fill in "Email" with "king@the.wd"
And I fill in "Affiliation" with "King of the world"
And I fill in "Content" with "Rock on"
And I press "Create Comment"
And I press "Send Comment"
Then I should see "Thank you. Your comment has been sent to the editor."
And a comment should exist with name: "Ben Dover", email: "king@the.wd", affiliation: "King of the world", content: "Rock on", user_id: nil
And 1 comments should exist
And I should be on the new comment page

Scenario: Create a comment belonging to a user
Given a user exists
And I am logged in as that user
When I go to the new comment page
And I fill in "Name" with "Ben Dover"
And I fill in "Email" with "king@the.wd"
And I fill in "Affiliation" with "King of the world"
And I fill in "Content" with "Rock on"
And I press "Create Comment"
And I press "Send Comment"
And a comment should exist with content: "Rock on", user_id: that user
And 1 comments should exist
