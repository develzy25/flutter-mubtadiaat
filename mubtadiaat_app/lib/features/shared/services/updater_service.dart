import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';

class GitHubRelease {
  final String tagName;
  final String name;
  final String body;
  final String htmlUrl;

  GitHubRelease({
    required this.tagName,
    required this.name,
    required this.body,
    required this.htmlUrl,
  });

  factory GitHubRelease.fromJson(Map<String, dynamic> json) {
    return GitHubRelease(
      tagName: json['tag_name'] ?? '',
      name: json['name'] ?? '',
      body: json['body'] ?? 'Tidak ada catatan pembaruan.',
      htmlUrl: json['html_url'] ?? '',
    );
  }
}

class UpdaterService {
  final Dio _dio = Dio();
  final String _repoOwner = 'develzy25';
  final String _repoName = 'flutter-mubtadiaat';

  Future<GitHubRelease?> checkForUpdate() async {
    try {
      final response = await _dio.get(
        'https://api.github.com/repos/$_repoOwner/$_repoName/releases/latest',
        options: Options(
          headers: {
            'Accept': 'application/vnd.github.v3+json',
            // Uncomment and add token if repository becomes private:
            // 'Authorization': 'token YOUR_GITHUB_PAT',
          },
        ),
      );

      if (response.statusCode == 200) {
        final latestRelease = GitHubRelease.fromJson(response.data);
        final packageInfo = await PackageInfo.fromPlatform();
        
        final currentVersion = packageInfo.version;
        final latestVersion = latestRelease.tagName.replaceAll('v', ''); // Assuming tag is like 'v1.0.25'

        if (_isNewerVersion(currentVersion, latestVersion)) {
          return latestRelease;
        }
      }
    } catch (e) {
      // Failed to check for update, ignore silently or log
      print('Update check failed: $e');
    }
    return null;
  }

  bool _isNewerVersion(String currentVersion, String latestVersion) {
    List<int> currentParts = currentVersion.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    List<int> latestParts = latestVersion.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    for (int i = 0; i < 3; i++) {
      int current = i < currentParts.length ? currentParts[i] : 0;
      int latest = i < latestParts.length ? latestParts[i] : 0;

      if (latest > current) return true;
      if (latest < current) return false;
    }
    return false; // Equal versions
  }
}
