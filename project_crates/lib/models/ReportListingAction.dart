class ReportListingAction{
  final String reportID;
  // List of all actions moderator chooses
  final List<String> actionsTaken;
  final String updateToReporter;
  final String updateToOffender;
  final String moderatorID;
  final DateTime actionDate;

  ReportListingAction({
    this.reportID, this.actionsTaken, this.updateToReporter, this.updateToOffender, this.moderatorID, this.actionDate
  });
}