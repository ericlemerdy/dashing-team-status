class Dashing.TeamStatus extends Dashing.Widget

  ready: ->
    @set 'url', (window.location + '/widgets/team-status-data-id')
    container = $(@node).parent()
    # Gross hacks. Let's fix this.
    width = (Dashing.widget_base_dimensions[0] * container.data("sizex")) + Dashing.widget_margins[0] * 2 * (container.data("sizex") - 1)
    height = (Dashing.widget_base_dimensions[1] * container.data("sizey"))
    @graph = new Rickshaw.Graph(
      element: @node
      width: width
      height: height
      renderer: @get("graphtype")
      series: [
        {
          color: "#fff",
          data: [
            {x:0, y:0},
            {x:1, y:0},
            {x:2, y:0},
            {x:3, y:0},
            {x:4, y:0},
            {x:5, y:0},
            {x:6, y:0},
            {x:7, y:0},
            {x:8, y:0},
            {x:9, y:0},
            {x:10, y:0},
            {x:11, y:0},
            {x:12, y:0},
            {x:13, y:0}
          ]
        }
      ]
    )
    @graph.series[0].data = @get('points') if @get('points')
    @graph.render()
    @dailyMood = 0
    @votesOfTheDay = 0

  onData: (data) ->
    @dailyMood = ((@votesOfTheDay * @dailyMood) + data.mood) / (@votesOfTheDay + 1)
    @votesOfTheDay++
    console.log @dailyMood, @votesOfTheDay
    @set 'dailyMood', Math.round @dailyMood
    @set 'votesOfTheDay', @votesOfTheDay
    classes = switch
      when data.mood == 0 then 'frown-o bad-day'
      when data.mood == 1 then 'frown-o hard-day'
      when data.mood == 2 then 'meh-o neutral-day'
      when data.mood == 3 then 'smile-o good-day'
      when data.mood == 4 then 'smile-o excellent-day'
    @set 'classes', classes
    if @graph
      last_x = @graph.series[0].data.shift().x + @graph.series[0].data.length + 1
      @graph.series[0].data.push {x:last_x + 1, y:data.mood}
      @graph.render()
