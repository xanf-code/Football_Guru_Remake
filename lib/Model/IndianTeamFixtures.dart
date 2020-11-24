class IndiaFixturesModel {
  String tournamentName;
  String eventStatus;
  int tournamentId;
  String homeTeamName;
  int homeTeamID;
  int homeTeamScore;
  String awayTeamName;
  int awayTeamID;
  int awayTeamScore;
  var datetime;
  IndiaFixturesModel({
    this.datetime,
    this.tournamentName,
    this.tournamentId,
    this.eventStatus,
    this.homeTeamName,
    this.homeTeamID,
    this.homeTeamScore,
    this.awayTeamName,
    this.awayTeamID,
    this.awayTeamScore,
  });
}
