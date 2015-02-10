request = require('request')

# see README.md for reference
KEY     = process.env.TRELLO_KEY
TOKEN   = process.env.TRELLO_TOKEN
DEFAULT = process.env.DEFAULT_BOARD
BOARDS  = process.env.BOARDS?.split(',')
  .map (b)->
    board = b.split(':')
    { prefix:board[0],id:board[1] }
BOARDS ||= []

return throw 'NO TRELLO_KEY' unless KEY
return throw 'NO TRELLO_TOKEN' unless TOKEN
return throw 'NO DEFAULT_BOARD' unless DEFAULT

module.exports = Trello =

  post: (prefix,short_id,message)->
    board = @get_board(prefix)
    ticket_uid = @get_ticket board, short_id, (id)->
      url = "https://api.trello.com/1/cards/#{id}/actions/comments?key=#{KEY}&token=#{TOKEN}"
      request
      .post url, (err)-> console.error err if err
      .form
        text: message

  get_ticket: (board,short_id,cb)->
    url = "https://api.trello.com/1/boards/#{board}/cards?key=#{KEY}&token=#{TOKEN}&fields=idShort"
    request.get url, (err,res,body)->
      return console.error(err) if err
      boarded_tickets = JSON.parse(body)
      id = boarded_tickets
                          .filter (t)-> parseInt(t.idShort,10) is parseInt(short_id,10)
                          .map (t)-> t.id
                          [0]
      return console.error('no corresponding ID') unless id
      cb(id)

  get_board: (prefix)->
    board = DEFAULT
    BOARDS.forEach (b)->
      board = b.id if b.prefix is prefix
    board