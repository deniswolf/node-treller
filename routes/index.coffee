express = require("express")
debug   = require('debug')('bubu')
router  = express.Router()
trello  = require('../lib/trello')

# GET home page.
router.get "/", (req, res) ->
  res.send 200, "Alles klar"

router.post "/", (req, res) ->
  body = req.body
  return res.send(403, 'no commits were found') unless body.commits

  commits = body.commits
  .filter (c)-> c.distinct
  .map (c)->
    id: c.id
    url: c.url
    message: c.message
    author: c.author.name
    branch: c.branch

  notifications = commits
  .map (c)->
    ids = c.message.match(/[\s]?[A-Za-z]*#[0-9]+/g)
    return null unless ids
    boards = ids
      .map (id)-> id.replace(' ','')
      .map (id)->
        id = id.split('#')
        { prefix: id[0], ticket_id: id[1] }

    boards: boards
    message: """
      Mentioned in #{c.id} by #{c.author} with desciption:\n
      #{c.message}\n
      #{c.url}
    """
  # filter out nulls
  .filter (c) -> c

  notifications.forEach (n)->
    message = n.message
    n.boards.forEach (board)-> trello.post(board.prefix, board.ticket_id, message)

  res.send 200, "notifications sent: #{notifications.length}."

module.exports = router
