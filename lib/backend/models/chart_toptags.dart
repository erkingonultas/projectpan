class ChartTopTags {
  Tags? tags;

  ChartTopTags({this.tags});

  ChartTopTags.fromJson(Map<String, dynamic> json) {
    tags = json['tags'] != null ? Tags.fromJson(json['tags']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (tags != null) {
      data['tags'] = tags!.toJson();
    }
    return data;
  }
}

class Tags {
  List<Tag>? tag;

  Tags({this.tag});

  Tags.fromJson(Map<String, dynamic> json) {
    if (json['tag'] != null) {
      tag = <Tag>[];
      json['tag'].forEach((v) {
        tag!.add(Tag.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (tag != null) {
      data['tag'] = tag!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Tag {
  String? name;
  String? url;
  String? reach;
  String? taggings;
  String? streamable;

  Tag({this.name, this.url, this.reach, this.taggings, this.streamable});

  Tag.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
    reach = json['reach'];
    taggings = json['taggings'];
    streamable = json['streamable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['url'] = url;
    data['reach'] = reach;
    data['taggings'] = taggings;
    data['streamable'] = streamable;
    return data;
  }
}
