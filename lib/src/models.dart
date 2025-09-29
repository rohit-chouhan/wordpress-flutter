import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

/// Represents a WordPress post with all its properties.
@JsonSerializable()
class Post {
  final int id;
  final String? date;
  final String? dateGmt;
  final Map<String, dynamic>? guid;
  final String? modified;
  final String? modifiedGmt;
  final String? slug;
  final String? status;
  final String? type;
  final String? link;
  final Map<String, dynamic>? title;
  final Map<String, dynamic>? content;
  final Map<String, dynamic>? excerpt;
  final int? author;
  final int? featuredMedia;
  final String? commentStatus;
  final String? pingStatus;
  final bool? sticky;
  final String? template;
  final String? format;
  final List<dynamic>? categories;
  final List<dynamic>? tags;
  final Map<String, dynamic>? meta;
  final Map<String, dynamic>? links;

  /// Creates a new Post instance.
  Post({
    required this.id,
    required this.date,
    required this.dateGmt,
    required this.guid,
    required this.modified,
    required this.modifiedGmt,
    required this.slug,
    required this.status,
    required this.type,
    required this.link,
    required this.title,
    required this.content,
    required this.excerpt,
    required this.author,
    required this.featuredMedia,
    required this.commentStatus,
    required this.pingStatus,
    required this.sticky,
    required this.template,
    required this.format,
    required this.categories,
    required this.tags,
    required this.meta,
    required this.links,
  });

  /// Creates a Post from JSON data.
  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);
  Map<String, dynamic> getFullResponse() => toJson();
}

/// Represents a WordPress page with all its properties.
@JsonSerializable()
class Page {
  final int id;
  final String? date;
  final String? dateGmt;
  final Map<String, dynamic>? guid;
  final String? modified;
  final String? modifiedGmt;
  final String? slug;
  final String? status;
  final String? type;
  final String? link;
  final Map<String, dynamic>? title;
  final Map<String, dynamic>? content;
  final Map<String, dynamic>? excerpt;
  final int? author;
  final int? featuredMedia;
  final int? parent;
  final int? menuOrder;
  final String? commentStatus;
  final String? pingStatus;
  final String? template;
  final Map<String, dynamic>? meta;
  final Map<String, dynamic>? links;

  /// Creates a new Page instance.
  Page({
    required this.id,
    required this.date,
    required this.dateGmt,
    required this.guid,
    required this.modified,
    required this.modifiedGmt,
    required this.slug,
    required this.status,
    required this.type,
    required this.link,
    required this.title,
    required this.content,
    required this.excerpt,
    required this.author,
    required this.featuredMedia,
    required this.parent,
    required this.menuOrder,
    required this.commentStatus,
    required this.pingStatus,
    required this.template,
    required this.meta,
    required this.links,
  });

  /// Creates a Page from JSON data.
  factory Page.fromJson(Map<String, dynamic> json) => _$PageFromJson(json);
  Map<String, dynamic> toJson() => _$PageToJson(this);
  Map<String, dynamic> getFullResponse() => toJson();
}

/// Represents a WordPress user with all its properties.
@JsonSerializable()
class User {
  final int id;
  final String? username;
  final String? name;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? url;
  final String? description;
  final String? link;
  final String? locale;
  final String? nickname;
  final String? slug;
  final List<dynamic>? roles;
  final String? registeredDate;
  final Map<String, dynamic>? capabilities;
  final Map<String, dynamic>? extraCapabilities;
  final List<dynamic>? meta;
  @JsonKey(name: 'avatar_urls')
  final Map<String, dynamic>? avatarUrls;
  @JsonKey(name: '_links')
  final Map<String, dynamic>? links;

  /// Creates a new User instance.
  User({
    required this.id,
    required this.username,
    required this.name,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.url,
    required this.description,
    required this.link,
    required this.locale,
    required this.nickname,
    required this.slug,
    required this.roles,
    required this.registeredDate,
    required this.capabilities,
    required this.extraCapabilities,
    required this.meta,
    required this.avatarUrls,
    required this.links,
  });

  /// Creates a User from JSON data.
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
  Map<String, dynamic> getFullResponse() => toJson();
}

/// Represents a WordPress category with all its properties.
@JsonSerializable()
class Category {
  final int id;
  final int? count;
  final String? description;
  final String? link;
  final String? name;
  final String? slug;
  final String? taxonomy;
  final int? parent;
  final List<dynamic>? meta;
  final Map<String, dynamic>? links;

  /// Creates a new Category instance.
  Category({
    required this.id,
    required this.count,
    required this.description,
    required this.link,
    required this.name,
    required this.slug,
    required this.taxonomy,
    required this.parent,
    required this.meta,
    required this.links,
  });

  /// Creates a Category from JSON data.
  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
  Map<String, dynamic> getFullResponse() => toJson();
}

/// Represents a WordPress tag with all its properties.
@JsonSerializable()
class Tag {
  final int id;
  final int? count;
  final String? description;
  final String? link;
  final String? name;
  final String? slug;
  final String? taxonomy;
  final List<dynamic>? meta;
  final Map<String, dynamic>? links;

  /// Creates a new Tag instance.
  Tag({
    required this.id,
    required this.count,
    required this.description,
    required this.link,
    required this.name,
    required this.slug,
    required this.taxonomy,
    required this.meta,
    required this.links,
  });

  /// Creates a Tag from JSON data.
  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
  Map<String, dynamic> toJson() => _$TagToJson(this);
  Map<String, dynamic> getFullResponse() => toJson();
}

/// Represents a WordPress comment with all its properties.
@JsonSerializable()
class Comment {
  final int id;
  final int? post;
  final int? parent;
  final int? author;
  final String? authorName;
  final String? authorEmail;
  final String? authorUrl;
  final String? authorIp;
  final String? date;
  final String? dateGmt;
  final Map<String, dynamic>? content;
  final String? status;
  final String? type;
  final String? link;
  final Map<String, dynamic>? meta;
  final Map<String, dynamic>? links;

  /// Creates a new Comment instance.
  Comment({
    required this.id,
    required this.post,
    required this.parent,
    required this.author,
    required this.authorName,
    required this.authorEmail,
    required this.authorUrl,
    required this.authorIp,
    required this.date,
    required this.dateGmt,
    required this.content,
    required this.status,
    required this.type,
    required this.link,
    required this.meta,
    required this.links,
  });

  /// Creates a Comment from JSON data.
  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);
  Map<String, dynamic> getFullResponse() => toJson();
}

/// Represents a WordPress media item with all its properties.
@JsonSerializable()
class Media {
  final int id;
  final String? date;
  final String? dateGmt;
  final Map<String, dynamic>? guid;
  final String? modified;
  final String? modifiedGmt;
  final String? slug;
  final String? status;
  final String? type;
  final String? link;
  final Map<String, dynamic>? title;
  final int? author;
  final String? commentStatus;
  final String? pingStatus;
  final String? template;
  final Map<String, dynamic>? meta;
  final Map<String, dynamic>? description;
  final Map<String, dynamic>? caption;
  final String? altText;
  final String? mediaType;
  final String? mimeType;
  final Map<String, dynamic>? mediaDetails;
  final int? post;
  final String? sourceUrl;
  final Map<String, dynamic>? links;

  /// Creates a new Media instance.
  Media({
    required this.id,
    required this.date,
    required this.dateGmt,
    required this.guid,
    required this.modified,
    required this.modifiedGmt,
    required this.slug,
    required this.status,
    required this.type,
    required this.link,
    required this.title,
    required this.author,
    required this.commentStatus,
    required this.pingStatus,
    required this.template,
    required this.meta,
    required this.description,
    required this.caption,
    required this.altText,
    required this.mediaType,
    required this.mimeType,
    required this.mediaDetails,
    required this.post,
    required this.sourceUrl,
    required this.links,
  });

  /// Creates a Media from JSON data.
  factory Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);
  Map<String, dynamic> toJson() => _$MediaToJson(this);
  Map<String, dynamic> getFullResponse() => toJson();
}
