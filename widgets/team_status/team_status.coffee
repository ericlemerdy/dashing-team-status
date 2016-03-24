class TeamStatusLib

  constructor: ->
    @supplementaryDays = 0
    @data = []
    @moods = [0, 0, 0, 0, 0]
    @votesOfTheDay = 0
    @lastDay = @getDate().getDay()
    @dailyMood = 0

  createDate: ->
    new Date()

  getDate: ->
    new Date(@createDate().getTime() + @supplementaryDays * 1000*60*60*24)

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
    todayDay = @getDate().getDay()
    newDay = (@lastDay != todayDay)
    if (newDay)
      @data.push @dailyMood
      @moods = [0, 0, 0, 0, 0]
      @dailyMood = 0
      @votesOfTheDay = 0
      @lastDay = todayDay
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
        renderer: @get 'graphtype'
        series: [
          {
            color: '#fff',
            data: [
              {x:0, y:0}, {x:1, y:0}, {x:2, y:0}, {x:3, y:0}, {x:4, y:0},
              {x:5, y:0}, {x:6, y:0}, {x:7, y:0}, {x:8, y:0}, {x:9, y:0},
              {x:10, y:0}, {x:11, y:0}, {x:12, y:0}, {x:13, y:0}
            ]
          }
        ]
      )
      @graph.series[0].data = @get('points') if @get('points')
      @graph.render()

    onData: (data) ->
      if (@graph && teamStatusLib.onData data)
        last_x = @graph.series[0].data.shift().x + @graph.series[0].data.length + 1
        @graph.series[0].data.push { x: last_x + 1, y: teamStatusLib.data[teamStatusLib.data.length - 1] }
        @graph.render()
      @set 'smileyClass', teamStatusLib.smileyClass
      @set 'moods', {
        'cry': teamStatusLib.moods[0],
        'unhappy': teamStatusLib.moods[1],
        'sleep': teamStatusLib.moods[2],
        'happy': teamStatusLib.moods[3],
        'laugh': teamStatusLib.moods[4]
      }
