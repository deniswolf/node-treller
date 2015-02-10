## Github2Trello
webhoot reciever that adds info about commit to the relevant ticket.

## Config
`TRELLO_KEY=key`
`TRELLO_TOKEN=token`
`DEFAULT_BOARD=board-id`
`BOARDS=prefix1:board1-id,prefix2:board2-id`

## Commits format
Add the following to commit message:
`#list-id` - post to default board
`prefix#list-id` - post to the board assosiated with prefix
