import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';
import 'dart:convert';
import 'dart:async';

class SevenTv {
  static const _searchEmotesQuery = r'''
    query SearchEmotes($query: String!, $page: Int, $sort: Sort, $limit: Int, $filter: EmoteSearchFilter) {
      emotes(query: $query, page: $page, sort: $sort, limit: $limit, filter: $filter) {
        count
        items {
          id
          name
          listed
          trending
          owner {
            id
            username
            display_name
            style {
              color
              __typename
            }
            __typename
          }
          flags
          host {
            url
            files {
              name
              format
              width
              height
              __typename
            }
            __typename
          }
          __typename
        }
        __typename
      }
    }
''';

  final _url = Uri.parse('https://7tv.io/v3/gql');
  final _client = HttpClient();

  // TODO: refactor the request creation into a seperate method to reduce code redundancy

  Stream<Stream<Emote>> getTrending(int chunkSize) async* {
    var currentPage = 1;
    final variables = {
      'query': '',
      'limit': chunkSize,
      'page': currentPage,
      'sort': {'value': 'popularity', 'order': 'DESCENDING'},
      'filter': {
        'category': 'TRENDING_DAY',
        'exact_match': false,
        'case_sensitive': false,
        'ignore_tags': false,
        'zero_width': false,
        'animated': false,
        'aspect_ratio': ''
      }
    };
    int countCollected = 0;
    int countTotal = -1;
    while (countTotal < 0 || countTotal > countCollected) {
      variables['page'] = currentPage;
      final req = await _client.postUrl(_url);
      req.headers.add(HttpHeaders.contentTypeHeader, ContentType.json.mimeType);
      req.write(jsonEncode({'query': _searchEmotesQuery, 'variables': variables}));
      final resp = await req.close();
      final transformer = EmoteTransformer();
      yield resp.transform(utf8.decoder).transform(transformer);
      countTotal = transformer.countTotal;
      countCollected += transformer.countCollected;
      currentPage++;
    }
  }

  Stream<Stream<Emote>> search(String searchText, int chunkSize) async* {
    var currentPage = 1;
    final variables = {
      'query': searchText,
      'limit': chunkSize,
      'page': currentPage,
      'sort': {'value': 'popularity', 'order': 'DESCENDING'},
      'filter': {
        'category': 'TOP',
        'exact_match': false,
        'case_sensitive': false,
        'ignore_tags': false,
        'zero_width': false,
        'animated': false,
        'aspect_ratio': ''
      }
    };
    int countCollected = 0;
    int countTotal = -1;
    while (countTotal < 0 || countTotal > countCollected) {
      variables['page'] = currentPage;
      final req = await _client.postUrl(_url);
      req.headers.add(HttpHeaders.contentTypeHeader, ContentType.json.mimeType);
      req.write(jsonEncode({'query': _searchEmotesQuery, 'variables': variables}));
      final resp = await req.close();
      final transformer = EmoteTransformer();
      yield resp.transform(utf8.decoder).transform(transformer);
      countTotal = transformer.countTotal;
      countCollected += transformer.countCollected;
      currentPage++;
    }
  }
}

class EmoteTransformer implements StreamTransformer<String, Emote> {
  final StreamController<Emote> _controller = StreamController();
  int countCollected = 0;
  int countTotal = -1;
  String _buffer = '';
  String _countBuffer = '';
  bool _collectCount = false;

  int _currentDepth = 0;
  bool _inStrVal = false;
  int _itemsArrayDepth = -1;

  @override
  Stream<Emote> bind(Stream<String> stream) {
    stream.listen(onListen);
    return _controller.stream;
  }

  Future onListen(String chunk) async {
    for (final c in chunk.split('')) {
      _buffer += c;
      if (_collectCount) {
        if (c == ',') {
          countTotal = int.parse(_countBuffer);
          _collectCount = false;
        } else if (c != ' ') {
          _countBuffer += c;
        }
      }
      if (c == '"') {
        _inStrVal = !_inStrVal;
      } else if (!_inStrVal) {
        if (countTotal < 0 && c == ':' && _buffer.replaceAll(' ', '').toLowerCase().endsWith('"count":')) {
          _collectCount = true;
        } else if (c == '{' || c == '[') {
          _currentDepth++;
          if (c == '[') {
            if (_buffer.replaceAll(' ', '').toLowerCase().endsWith('"items":[')) {
              _itemsArrayDepth = _currentDepth;
              //clear buffer because it now collects emote json
              _buffer = '';
            }
          }
        } else if (c == '}' || c == ']') {
          if (_currentDepth == _itemsArrayDepth + 1 && c == '}') {
            //emote object closed
            countCollected++;
            _controller.add(Emote.fromJson(jsonDecode(_buffer.substring(_buffer.indexOf('{')))));
            _buffer = '';
          }
          if (_currentDepth == _itemsArrayDepth && _itemsArrayDepth > 0) {
            //we are done
            await _controller.close();
          }
          _currentDepth--;
        }
      }
    }
  }

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() {
    return StreamTransformer.castFrom(this);
  }
}

class Emote {
  late String id;
  late String name;
  bool? listed;
  Owner? owner;
  int? flags; //TODO: convert flags to enum
  Host? host;

  Emote(this.id, this.name, {this.listed, this.owner, this.flags, this.host});

  Emote.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    listed = json['listed'];
    owner = json['owner'] != null ? Owner.fromJson(json['owner']) : null;
    flags = json['flags'];
    host = json['host'] != null ? Host.fromJson(json['host']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['listed'] = listed;
    if (owner != null) {
      data['owner'] = owner!.toJson();
    }
    data['flags'] = flags;
    if (host != null) {
      data['host'] = host!.toJson();
    }
    return data;
  }

  Uri getMaxSizeUrl({Format format = Format.webp}) => host!.getUrl(
      host!.files!.where((f) => f.format == format).reduce((a, b) => a.height > b.height ? a : b));

  File getMaxSizeFile({Format format = Format.webp}) =>
      host!.files!.reduce((a, b) => a.height > b.height ? a : b);
}

class Owner {
  String? id;
  String? username;
  String? displayName;
  Style? style; //TODO: replace style with color

  Owner({this.id, this.username, this.displayName, this.style});

  Owner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    displayName = json['display_name'];
    style = json['style'] != null ? Style.fromJson(json['style']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['display_name'] = displayName;
    if (style != null) {
      data['style'] = style!.toJson();
    }
    return data;
  }
}

class Style {
  int? color;

  Style({this.color});

  Style.fromJson(Map<String, dynamic> json) {
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['color'] = color;
    return data;
  }
}

class Host {
  late String url;
  List<File>? files;

  // Host({this.url, this.files});

  Uri getUrl(File file) => Uri.parse('https:$url/${file.name}');

  Host.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    if (json['files'] != null) {
      files = <File>[];
      json['files'].forEach((v) {
        files!.add(File.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    if (files != null) {
      data['files'] = files!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Future<bool> checkIfAnimated(File file) async {
    final http = HttpClient();
    final request = await http.getUrl(getUrl(file));
    final response = await request.close();

    final bytes = await response.take(34).first as Uint8List;

    // Check that the header is present
    if (utf8.decode(bytes.sublist(0, 4), allowMalformed: true) != 'RIFF' ||
        utf8.decode(bytes.sublist(8, 12), allowMalformed: true) != 'WEBP') {
      throw "url does not lead to a valid webp";
    }
    // Check if the file is animated by looking for the "ANIM" chunk identifier
    final isAnimated = listEquals(bytes.sublist(30, 30 + 4), utf8.encode('ANIM') as Uint8List);
    return isAnimated;
  }
}

class File {
  late String name;
  late Format format;
  late int width;
  late int height;

  // File({this.name, this.format = Format.webp, this.width, this.height});

  File.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    format = Format.values.byName((json['format'] as String).toLowerCase());
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['format'] = format.name.toUpperCase();
    data['width'] = width;
    data['height'] = height;
    return data;
  }
}

enum Format { avif, webp }
