Feature:

@view
Scenario: Index view
Given a user exists with roles_mask: 2, username: "dover"
And a comment exists with name: "Ben Dover", email: "king@the.wd", affiliation: "King of the world", content: "Rock on", user: that user
And I am logged in as that user
When I go to the comments page
Then I should see "Ben Dover (dover) <king@the.wd>" within the first "comments" listing
And I should see "Affiliation: King of the world" within the first "comments" listing
And I should see "Comment: Rock on" within the first "comments" listing

Scenario: A member can only see his own comment
Given a user "correct" exists with roles_mask: 8
And a user "wrong" exists
And I am logged in as user "correct"
And a comment exists with content: "A comment", user: user "correct"
And a comment exists with content: "A second comment", user: user "wrong"
When I go to the comments page
Then I should see "A comment" within the first "comments" listing
But I should see no second "comments" listing
