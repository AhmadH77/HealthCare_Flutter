class AppUser {
  /// medical Stuff 1 // patient 2
  final int accountType;
  final String name, email, gender,
      password, id, status, latitude, longitude;
  String? distance;

  AppUser(this.id, this.accountType, this.name,
      this.email, this.gender,this.password,
      this.status, this.latitude, this.longitude,
      {this.distance});
}
