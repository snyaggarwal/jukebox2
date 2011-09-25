class Files

  constructor: ->
    @validFiles = $('body').attr('data-accept')
    @notification = new FileNotification '#notifications', '#file-notification'
    @uploader = new Uploader
      method: 'POST'
      url: '/library/upload'

    document.addEventListener "dragenter", @stopActions, false
    document.addEventListener "dragexit", @stopActions, false
    document.addEventListener "dragover", @stopActions, false
    document.addEventListener "drop", @stopActions, false
    document.addEventListener "drop", @render, false

  isAcceptable: (type) ->
    new RegExp(@validFiles, 'gi').test(type)

  render: (evt) =>
    for file in evt.dataTransfer.files
      continue unless @isAcceptable file.type
      $element = @notification.render
        name: file.name
        size: @sizeInMb(file.size)
      @uploader.send file, $element

  sizeInMb: (size) ->
    Math.round parseInt(size) / 1048576

  stopActions: (evt) ->
    evt.stopPropagation()
    evt.preventDefault()


$ -> new Files