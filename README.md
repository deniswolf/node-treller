## Github2Trello

Webhook reciever for adding info about commit to the relevant ticket.

## Config
```bash
TRELLO_KEY=key
TRELLO_TOKEN=token
DEFAULT_BOARD=board-id
BOARDS=prefix1:board1-id,prefix2:board2-id
```

## Format for the commit messages
Add the following to the message:

* `#list-id` - post to the default board
* `prefix#list-id` - post to the board assosiated with this prefix
