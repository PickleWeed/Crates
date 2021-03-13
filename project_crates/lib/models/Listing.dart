class Listing {
  bool isRequest;
  String category;
  String itemName;
  String description;
  DateTime postDateTime;
  String userID;

  Listing(
      {this.isRequest,
      this.category,
      this.itemName,
      this.description,
      this.postDateTime,
      this.userID});
}
