class TagTopArtists {
  Topartists? topartists;

  TagTopArtists({this.topartists});

  TagTopArtists.fromJson(Map<String, dynamic> json) {
    topartists = json['topartists'] != null ? Topartists.fromJson(json['topartists']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (topartists != null) {
      data['topartists'] = topartists!.toJson();
    }
    return data;
  }
}

class Topartists {
  List<Artist>? artist;
  Attr? attr;

  Topartists({this.artist});

  Topartists.fromJson(Map<String, dynamic> json) {
    if (json['artist'] != null) {
      artist = <Artist>[];
      json['artist'].forEach((v) {
        artist!.add(Artist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (artist != null) {
      data['artist'] = artist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Artist {
  String? name;
  String? mbid;
  String? url;
  String? streamable;
  List<ArtistImage>? image;
  Attr? attr;

  Artist({this.name, this.mbid, this.url, this.streamable, this.image, this.attr});

  Artist.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mbid = json['mbid'];
    url = json['url'];
    streamable = json['streamable'];
    if (json['image'] != null) {
      image = <ArtistImage>[];
      json['image'].forEach((v) {
        image!.add(ArtistImage.fromJson(v));
      });
    }
    attr = json['@attr'] != null ? Attr.fromJson(json['@attr']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['mbid'] = mbid;
    data['url'] = url;
    data['streamable'] = streamable;
    if (image != null) {
      data['image'] = image!.map((v) => v.toJson()).toList();
    }
    if (attr != null) {
      data['@attr'] = attr!.toJson();
    }
    return data;
  }
}

class ArtistImage {
  String? text;
  String? size;

  ArtistImage({this.text, this.size});

  ArtistImage.fromJson(Map<String, dynamic> json) {
    text = json['#text'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['#text'] = text;
    data['size'] = size;
    return data;
  }
}

class Attr {
  String? rank;

  Attr({this.rank});

  Attr.fromJson(Map<String, dynamic> json) {
    rank = json['rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rank'] = rank;
    return data;
  }
}
