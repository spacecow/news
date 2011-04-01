Feature:

Scenario:
Given a comment exists with name: "Ben Dover", email: "king@the.wd", affiliation: "King of the world", content: "Rock on", user_id: nil
And a user exists with roles_mask: 2
And I am logged in as that user
When I go to that comment's edit page
And I fill in "Affiliation" with "King of the whole wide world!"
And I press "Update Comment"
Then I should see "Successfully updated comment."
And a comment should exist with name: "Ben Dover", email: "king@the.wd", affiliation: "King of the whole wide world!", content: "Rock on", user_id: nil
And 1 comments should exist
And I should be on the new comment page

