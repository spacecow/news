Feature:

Scenario: A member can only see his own comment
Given a user "correct" exists with roles_mask: 8
And a user "wrong" exists
And I am logged in as user "correct"
And a comment exists with content: "A comment", user: user "correct"
And a comment exists with content: "A second comment", user: user "wrong"
When I go to the comments page
Then I should see "A comment" within the second "comments" table row
But I should see no third "comments" table row
