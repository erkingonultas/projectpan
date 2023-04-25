class EventModel {
  List<Events>? events;
  //Meta? meta;

  EventModel({
    this.events,
    //  this.meta,
  });

  EventModel.fromJson(Map<String, dynamic> json) {
    if (json['events'] != null) {
      events = <Events>[];
      json['events'].forEach((v) {
        events!.add(Events.fromJson(v));
      });
    }
    // meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (events != null) {
      data['events'] = events!.map((v) => v.toJson()).toList();
    }
    // if (meta != null) {
    //   data['meta'] = meta!.toJson();
    // }
    return data;
  }
}

class Events {
  String? type;
  int? id;
  String? datetimeLocal;
  Venue? venue;
  List<Performers>? performers;
  String? url;
  //double? score;
  String? announceDate;
  String? description;

  Events({
    this.type,
    this.id,
    this.datetimeLocal,
    this.venue,
    this.performers,
    this.url,
    // this.score,
    this.announceDate,
    this.description,
  });

  Events.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    datetimeLocal = json['datetime_local'];
    venue = json['venue'] != null ? Venue.fromJson(json['venue']) : null;
    if (json['performers'] != null) {
      performers = <Performers>[];
      json['performers'].forEach((v) {
        performers!.add(Performers.fromJson(v));
      });
    }
    url = json['url'];
    //score = json['score'];
    announceDate = json['announce_date'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['id'] = id;
    data['datetime_local'] = datetimeLocal;
    if (venue != null) {
      data['venue'] = venue!.toJson();
    }
    if (performers != null) {
      data['performers'] = performers!.map((v) => v.toJson()).toList();
    }
    data['url'] = url;
    // data['score'] = score;
    data['announce_date'] = announceDate;
    data['description'] = description;
    return data;
  }
}

class Venue {
  String? state;
  String? name;
  double? score;
  Location? location;
  String? address;
  int? id;
  String? displayLocation;

  Venue({this.state, this.name, this.score, this.location, this.address, this.id, this.displayLocation});

  Venue.fromJson(Map<String, dynamic> json) {
    state = json['state'];
    name = json['name'];
    score = json['score'];
    location = json['location'] != null ? Location.fromJson(json['location']) : null;
    address = json['address'];
    id = json['id'];
    displayLocation = json['display_location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['state'] = state;
    data['name'] = name;
    data['score'] = score;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['address'] = address;
    data['id'] = id;
    data['display_location'] = displayLocation;
    return data;
  }
}

class Location {
  double? lat;
  double? lon;

  Location({this.lat, this.lon});

  Location.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lon = json['lon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lon'] = lon;
    return data;
  }
}

class Performers {
  String? type;
  String? name;
  int? id;
  Images? images;
  String? imageAttribution;
  String? url;
  double? score;
  List<Genres>? genres;

  Performers({this.type, this.name, this.id, this.images, this.imageAttribution, this.url, this.score, this.genres});

  Performers.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    name = json['name'];
    id = json['id'];
    images = json['images'] != null ? Images.fromJson(json['images']) : null;
    imageAttribution = json['image_attribution'];
    url = json['url'];
    score = json['score'];
    if (json['genres'] != null) {
      genres = <Genres>[];
      json['genres'].forEach((v) {
        genres!.add(Genres.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['name'] = name;
    data['id'] = id;
    if (images != null) {
      data['images'] = images!.toJson();
    }
    data['image_attribution'] = imageAttribution;
    data['url'] = url;
    data['score'] = score;
    if (genres != null) {
      data['genres'] = genres!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Images {
  String? huge;

  Images({this.huge});

  Images.fromJson(Map<String, dynamic> json) {
    huge = json['huge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['huge'] = huge;
    return data;
  }
}

class Genres {
  int? id;
  String? name;
  GenreImages? images;

  Genres({this.id, this.name, this.images});

  Genres.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    images = json['images'] != null ? GenreImages.fromJson(json['images']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (images != null) {
      data['images'] = images!.toJson();
    }
    return data;
  }
}

class GenreImages {
  String? s1200x525;
  String? s1200x627;
  String? s136x136;
  String? s500700;
  String? s800x320;
  String? banner;
  String? block;
  String? criteo130160;
  String? criteo170235;
  String? criteo205100;
  String? criteo400300;
  String? fb100x72;
  String? fb600315;
  String? huge;
  String? ipadEventModal;
  String? ipadHeader;
  String? ipadMiniExplore;
  String? mongo;
  String? squareMid;
  String? triggitFbAd;

  GenreImages(
      {this.s1200x525,
      this.s1200x627,
      this.s136x136,
      this.s500700,
      this.s800x320,
      this.banner,
      this.block,
      this.criteo130160,
      this.criteo170235,
      this.criteo205100,
      this.criteo400300,
      this.fb100x72,
      this.fb600315,
      this.huge,
      this.ipadEventModal,
      this.ipadHeader,
      this.ipadMiniExplore,
      this.mongo,
      this.squareMid,
      this.triggitFbAd});

  GenreImages.fromJson(Map<String, dynamic> json) {
    s1200x525 = json['1200x525'];
    s1200x627 = json['1200x627'];
    s136x136 = json['136x136'];
    s500700 = json['500_700'];
    s800x320 = json['800x320'];
    banner = json['banner'];
    block = json['block'];
    criteo130160 = json['criteo_130_160'];
    criteo170235 = json['criteo_170_235'];
    criteo205100 = json['criteo_205_100'];
    criteo400300 = json['criteo_400_300'];
    fb100x72 = json['fb_100x72'];
    fb600315 = json['fb_600_315'];
    huge = json['huge'];
    ipadEventModal = json['ipad_event_modal'];
    ipadHeader = json['ipad_header'];
    ipadMiniExplore = json['ipad_mini_explore'];
    mongo = json['mongo'];
    squareMid = json['square_mid'];
    triggitFbAd = json['triggit_fb_ad'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['1200x525'] = s1200x525;
    data['1200x627'] = s1200x627;
    data['136x136'] = s136x136;
    data['500_700'] = s500700;
    data['800x320'] = s800x320;
    data['banner'] = banner;
    data['block'] = block;
    data['criteo_130_160'] = criteo130160;
    data['criteo_170_235'] = criteo170235;
    data['criteo_205_100'] = criteo205100;
    data['criteo_400_300'] = criteo400300;
    data['fb_100x72'] = fb100x72;
    data['fb_600_315'] = fb600315;
    data['huge'] = huge;
    data['ipad_event_modal'] = ipadEventModal;
    data['ipad_header'] = ipadHeader;
    data['ipad_mini_explore'] = ipadMiniExplore;
    data['mongo'] = mongo;
    data['square_mid'] = squareMid;
    data['triggit_fb_ad'] = triggitFbAd;
    return data;
  }
}

// class Meta {
//   int? total;
//   int? took;
//   int? page;
//   int? perPage;
//   Null? geolocation;

//   Meta({this.total, this.took, this.page, this.perPage, this.geolocation});

//   Meta.fromJson(Map<String, dynamic> json) {
//     total = json['total'];
//     took = json['took'];
//     page = json['page'];
//     perPage = json['per_page'];
//     geolocation = json['geolocation'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['total'] = total;
//     data['took'] = took;
//     data['page'] = page;
//     data['per_page'] = perPage;
//     data['geolocation'] = geolocation;
//     return data;
//   }
// }
