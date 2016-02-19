part of file.src.backends.memory;

/// An implementation of [FileSystem] that exists entirely in memory.
///
/// [MemoryFileSystem] is suitable for mocking and tests, as well as for
/// caching or staging before writing or reading to a live system.
///
/// **NOTE**: This class is not yet optimized and should not be used for
/// performance-sensitive operations. There is also no implementation today for
/// symbolic [Link]s.
class MemoryFileSystem implements FileSystem {
  final Map<String, Object> _data;

  /// Create a new, empty in-memory file system.
  factory MemoryFileSystem() {
    return new MemoryFileSystem._(<String, Object>{});
  }

  // Prevent extending this class.
  MemoryFileSystem._(this._data);

  @override
  Directory directory(String path) {
    return new _MemoryDirectory(this, path == '/' ? '' : path);
  }

  @override
  File file(String path) => new _MemoryFile(this, path);

  /// Returns a Map equivalent to the file structure of the file system.
  ///
  // See [InMemoryFileSystem.fromMap] for details on the structure.
  Map<String, Object> toMap() => cloneSafe(_data);

  @override
  Future<FileSystemEntityType> type(String path, {bool followLinks: true}) {
    return new Future<FileSystemEntityType>.value(
        getType(_data, path, followLinks));
  }
}
