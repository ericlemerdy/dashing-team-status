if describe?
  describe 'Jasmine', ->
    it 'should run', ->
      expect(true).toBe true
  
  TeamStatusLib = require './team_status.coffee'
  
  describe 'Team Status Lib', ->
    teamStatusLib = null
  
    beforeEach ->
      global.window = { 'location': { 'protocol': 'http:', 'host': 'foo:1234' } };
  
    beforeEach ->
      spyOn(TeamStatusLib.prototype, 'createDate').andReturn(new Date(1981, 11, 24, 10, 0, 0))
      teamStatusLib = new TeamStatusLib
  
    it 'should create a TeamStatusLib object', ->
      expect(teamStatusLib).toBeDefined
  
    describe 'at initialisation', ->
      it 'should have zero supplementary day', ->
        expect(teamStatusLib.supplementaryDays).toBe 0
  
      it 'should have the current last day', ->
        expect(teamStatusLib.lastDay).toBe 4
  
      it 'should have no data', ->
        expect(teamStatusLib.data.length).toBe 0
  
      it 'should have no mood', ->
        expect(teamStatusLib.dailyMood).toBe 0
  
    describe 'passing days', ->
      it 'should advance days', ->
        teamStatusLib.onNextDay()
        expect(teamStatusLib.supplementaryDays).toBe 1
  
      it 'should advance days by sending post data', ->
        teamStatusLib.onData({ 'nextDay': true })
        expect(teamStatusLib.supplementaryDays).toBe 1
  
      it 'should get next day', ->
        expect(teamStatusLib.getDate().getDay()).toBe 4
        teamStatusLib.onNextDay()
        teamStatusLib.onNextDay()
        expect(teamStatusLib.getDate().getDay()).toBe 6
  
    it 'should generate curl url', ->
      expect(teamStatusLib.url()).toBe 'http://foo:1234/widgets/team-status-data-id'
  
    it 'should associate a class for each mood', ->
      expect(teamStatusLib.getSmileyClassOf 0).toBe 'cry'
      expect(teamStatusLib.getSmileyClassOf 1).toBe 'unhappy'
      expect(teamStatusLib.getSmileyClassOf 2).toBe 'sleep'
      expect(teamStatusLib.getSmileyClassOf 3).toBe 'happy'
      expect(teamStatusLib.getSmileyClassOf 4).toBe 'laugh'
  
    it 'when three moods are received, should influence the average.', ->
      teamStatusLib.onMood { 'mood': 1 }
      teamStatusLib.onMood { 'mood': 2 }
      teamStatusLib.onMood { 'mood': 3 }

      expect(teamStatusLib.votesOfTheDay).toBe 3
      expect(teamStatusLib.dailyMood).toBe 2
  
    it 'when a day pass, should save the daily mood.', ->
      teamStatusLib.onMood { 'mood': 4 }
      teamStatusLib.onNextDay()
      teamStatusLib.onMood { 'mood': 2 }
  
      expect(teamStatusLib.votesOfTheDay).toBe 1
      expect(teamStatusLib.dailyMood).toBe 2
      expect(teamStatusLib.data).toContain 4
  