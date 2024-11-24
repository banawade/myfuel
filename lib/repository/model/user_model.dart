class User {
  String? fName;
  String? lName;
  String? email;
  String? phone;
  String? password;
  String? address;
  String? pan;
  String? msme;
  String? gst;
  String? profile;
  String? guest_id;

  User(
      {this.fName,
      this.lName,
      this.email,
      this.phone,
      this.password,
      this.address,
      this.pan,
      this.msme,
      this.gst,
      this.profile,
      this.guest_id});

  User.fromJson(Map<String, dynamic> json) {
    fName = json['f_name'];
    lName = json['l_name'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    address = json['address'];
    guest_id = json['guest_id'];
    pan = json['pan'];
    msme = json['msme'];
    gst = json['gst'];
    profile = json['profile'];
    guest_id = json['guest_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['email'] = email;
    data['phone'] = phone;
    data['password'] = password;
    data['address'] = address;
    data['guest_id'] = guest_id;
    data['pan'] = pan;
    data['msme'] = msme;
    data['gst'] = gst;
    data['profile'] = profile;
    return data;
  }
}

class UpdateProfile {
  String? fName;
  String? lName;
  String? email;
  String? phone;
  String? password;

  UpdateProfile({
    this.fName,
    this.lName,
    this.email,
    this.phone,
    this.password,
  });

  UpdateProfile.fromJson(Map<String, dynamic> json) {
    fName = json['f_name'];
    lName = json['l_name'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['email'] = email;
    data['phone'] = phone;
    data['password'] = password;

    return data;
  }
}
