Feature:

Scenario Outline: Validate presence
When I go to the new comment page
And I press "Send Comment"
Then I should see <exist> comment <attr> error "<jap>を入力してください"
Examples:
| attr        | exist | jap      |
| name        | a     | 名前     |
| email       | no    | Eメール  |
| affiliation | no    | 所属     |
| content     | a     | コメント |

Scenario Outline: Email validation should only occur if it's filled in
When I go to the new comment page
And I fill in "Email" with "<input>"
And I press "Send Comment"
Then I should see <exist> comment email error
Examples:
| input | exist |
|       | no    |
| some  | a     |
