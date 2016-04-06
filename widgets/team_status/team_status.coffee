class TeamStatusLib

  constructor: ->
    @supplementaryDays = 0
    @data = []
    @moods = [0, 0, 0, 0, 0]
    @votesOfTheDay = 0
    @yesterday = @getDate()
    @dailyMood = 0
    @datas = ({ 'x': @getDatePlus(-day).getTime() / 1000, 'y': 0 } for day in [13..0])

  getDatas: ->
    @datas

  createDate: ->
    new Date()

  getDatePlus: (days) ->
    new Date(@createDate().getTime() + days * 1000*60*60*24)

  getDate: ->
    @getDatePlus @supplementaryDays

  url: ->
    window.location.protocol + '//' + window.location.host + '/widgets/team-status-data-id'

  getSmileyClassOf: (mood) ->
    switch
      when mood < 1 then 'cry'
      when mood < 2 then 'unhappy'
      when mood < 3 then 'sleep'
      when mood < 4 then 'happy'
      when mood < 5 then 'laugh'

  onNextDay: () ->
    @supplementaryDays = @supplementaryDays + 1

  onMood: (data) ->
    @moods[data.mood] = @moods[data.mood] + 1
    today = @getDate()
    newDay = (@yesterday.getDay() != today.getDay())
    if (newDay)
      @data.push { 'x': @yesterday.getTime() / 1000, 'y': @dailyMood }
      @moods = [0, 0, 0, 0, 0]
      @dailyMood = 0
      @votesOfTheDay = 0
      @yesterday = today
    @dailyMood = ((@votesOfTheDay * @dailyMood) + data.mood) / (@votesOfTheDay + 1)
    @smileyClass = @getSmileyClassOf @dailyMood
    @votesOfTheDay = @votesOfTheDay + 1
    newDay

  onData: (data) ->
    if (data.nextDay)
      @onNextDay()
      false
    else
      @onMood data

if module?
  module.exports = TeamStatusLib

if Dashing?
  class Dashing.TeamStatus extends Dashing.Widget

    teamStatusLib = new TeamStatusLib

    ready: ->
      @set 'url', teamStatusLib.url()
      container = $(@node).parent()
      # Gross hacks. Let's fix this.
      width = (Dashing.widget_base_dimensions[0] * container.data("sizex")) + Dashing.widget_margins[0] * 2 * (container.data("sizex") - 1)
      height = (Dashing.widget_base_dimensions[1] * container.data("sizey"))
      @graph = new Rickshaw.Graph(
        element: @node
        width: width
        height: height
        series: [
          {
            color: '#fff',
            data: teamStatusLib.getDatas()
          }
        ]
      )
      @graph.series[0].data = @get('points') if @get('points')
      x_axis = new Rickshaw.Graph.Axis.Time({ graph: @graph })
      @graph.render()

    onData: (data) ->
      if (@graph && teamStatusLib.onData data)
        @graph.series[0].data.shift()
        point = teamStatusLib.data[teamStatusLib.data.length - 1]
        @graph.series[0].data.push { x: point.x, y: point.y }
        @graph.render()
      @set 'smileyClass', teamStatusLib.smileyClass
      @set 'moods', {
        'cry': teamStatusLib.moods[0],
        'unhappy': teamStatusLib.moods[1],
        'sleep': teamStatusLib.moods[2],
        'happy': teamStatusLib.moods[3],
        'laugh': teamStatusLib.moods[4]
      }
