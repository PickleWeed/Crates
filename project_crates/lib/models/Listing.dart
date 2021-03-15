class Listing {
  bool isRequest;
  String category;
  String listingTitle;
  String description;
  double latitude;
  double longitude;
  DateTime postDateTime;
  String userID;

  Listing(
      {this.isRequest,
      this.category,
      this.listingTitle,
      this.description,
      this.postDateTime,
      this.userID,
      this.latitude,
      this.longitude});
}
