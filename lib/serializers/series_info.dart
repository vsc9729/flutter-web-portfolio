class SeriesInfo {
  String? page;
  String? next;
  int? entries;
  List<ShowData>? shows;

  SeriesInfo({this.page, this.next, this.entries, this.shows});

  SeriesInfo.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    next = json['next'];
    entries = json['entries'];
    if (json['results'] != null) {
      shows = <ShowData>[];
      json['results'].forEach((v) {
        shows!.add(ShowData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['next'] = next;
    data['entries'] = entries;
    if (shows != null) {
      data['results'] = shows!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShowData {
  String? sId;
  String? id;
  PrimaryImage? primaryImage;
  TitleType? titleType;
  TitleText? titleText;
  TitleText? originalTitleText;
  RatingsSummary? ratingsSummary;
  ReleaseYear? releaseYear;
  ReleaseDate? releaseDate;
  int? position;

  ShowData(
      {this.sId,
      this.id,
      this.primaryImage,
      this.titleType,
      this.titleText,
      this.ratingsSummary,
      this.originalTitleText,
      this.releaseYear,
      this.releaseDate,
      this.position});

  ShowData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    id = json['id'];
    primaryImage = json['primaryImage'] != null
        ? PrimaryImage.fromJson(json['primaryImage'])
        : null;
    titleType = json['titleType'] != null
        ? TitleType.fromJson(json['titleType'])
        : null;
    titleText = json['titleText'] != null
        ? TitleText.fromJson(json['titleText'])
        : null;
    originalTitleText = json['originalTitleText'] != null
        ? TitleText.fromJson(json['originalTitleText'])
        : null;
    releaseYear = json['releaseYear'] != null
        ? ReleaseYear.fromJson(json['releaseYear'])
        : null;
    releaseDate = json['releaseDate'] != null
        ? ReleaseDate.fromJson(json['releaseDate'])
        : null;
    position = json['position'];
    ratingsSummary = json['ratingsSummary'] != null
        ? RatingsSummary.fromJson(json['ratingsSummary'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['id'] = id;
    if (primaryImage != null) {
      data['primaryImage'] = primaryImage!.toJson();
    }
    if (titleType != null) {
      data['titleType'] = titleType!.toJson();
    }
    if (titleText != null) {
      data['titleText'] = titleText!.toJson();
    }
    if (originalTitleText != null) {
      data['originalTitleText'] = originalTitleText!.toJson();
    }
    if (releaseYear != null) {
      data['releaseYear'] = releaseYear!.toJson();
    }
    if (releaseDate != null) {
      data['releaseDate'] = releaseDate!.toJson();
    }
    data['position'] = position;
    return data;
  }
}

class PrimaryImage {
  String? id;
  int? width;
  int? height;
  String? url;
  Caption? caption;
  String? sTypename;

  PrimaryImage(
      {this.id,
      this.width,
      this.height,
      this.url,
      this.caption,
      this.sTypename});

  PrimaryImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    width = json['width'];
    height = json['height'];
    url = json['url'];
    caption =
        json['caption'] != null ? Caption.fromJson(json['caption']) : null;
    sTypename = json['__typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['width'] = width;
    data['height'] = height;
    data['url'] = url;
    if (caption != null) {
      data['caption'] = caption!.toJson();
    }
    data['__typename'] = sTypename;
    return data;
  }
}

class Caption {
  String? plainText;
  String? sTypename;

  Caption({this.plainText, this.sTypename});

  Caption.fromJson(Map<String, dynamic> json) {
    plainText = json['plainText'];
    sTypename = json['__typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['plainText'] = plainText;
    data['__typename'] = sTypename;
    return data;
  }
}

class TitleType {
  String? text;
  String? id;
  bool? isSeries;
  bool? isEpisode;
  String? sTypename;

  TitleType(
      {this.text, this.id, this.isSeries, this.isEpisode, this.sTypename});

  TitleType.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    id = json['id'];
    isSeries = json['isSeries'];
    isEpisode = json['isEpisode'];
    sTypename = json['__typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['id'] = id;
    data['isSeries'] = isSeries;
    data['isEpisode'] = isEpisode;
    data['__typename'] = sTypename;
    return data;
  }
}

class TitleText {
  String? text;
  String? sTypename;

  TitleText({this.text, this.sTypename});

  TitleText.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    sTypename = json['__typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['__typename'] = sTypename;
    return data;
  }
}

class ReleaseYear {
  int? year;
  int? endYear;
  String? sTypename;

  ReleaseYear({this.year, this.endYear, this.sTypename});

  ReleaseYear.fromJson(Map<String, dynamic> json) {
    year = json['year'];
    endYear = json['endYear'];
    sTypename = json['__typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['year'] = year;
    data['endYear'] = endYear;
    data['__typename'] = sTypename;
    return data;
  }
}

class ReleaseDate {
  int? day;
  int? month;
  int? year;
  String? sTypename;

  ReleaseDate({this.day, this.month, this.year, this.sTypename});

  ReleaseDate.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    month = json['month'];
    year = json['year'];
    sTypename = json['__typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = day;
    data['month'] = month;
    data['year'] = year;
    data['__typename'] = sTypename;
    return data;
  }
}

class RatingsSummary {
  double? aggregateRating;
  int? voteCount;
  String? sTypename;

  RatingsSummary({this.aggregateRating, this.voteCount, this.sTypename});

  RatingsSummary.fromJson(Map<String, dynamic> json) {
    aggregateRating = json['aggregateRating'];
    voteCount = json['voteCount'];
    sTypename = json['__typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['aggregateRating'] = aggregateRating;
    data['voteCount'] = voteCount;
    data['__typename'] = sTypename;
    return data;
  }
}
