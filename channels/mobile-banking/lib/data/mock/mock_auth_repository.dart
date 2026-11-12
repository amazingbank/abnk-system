import '../../core/errors/app_exception.dart';
import '../models/user.dart';
import '../repositories/auth_repository.dart';
import 'fixture_bundle.dart';

/// [AuthRepository] 的 mock 实现——凭据来自 `fixtures/<locale>/me.json` 的
/// demoUsers 段（原型专用明文口令，生产走 PBKDF2 凭据校验，D2 决策）。
/// EN: mock [AuthRepository] — credentials come from the demoUsers section
/// of `fixtures/<locale>/me.json` (prototype-only plaintext passwords;
/// production authenticates with PBKDF2, decision D2).
class MockAuthRepository implements AuthRepository {
  MockAuthRepository({this.latency = const Duration(milliseconds: 300)});

  /// 模拟网关往返延迟。
  final Duration latency;

  @override
  Future<Session> login(String username, String password) async {
    await Future<void>.delayed(latency);
    final data = await FixtureBundle.load('me.json');
    final demoUsers =
        (data['demoUsers'] as List).whereType<Map<String, dynamic>>();
    final hit = demoUsers.where((u) =>
        u['username'] == username && u['password'] == password);
    if (hit.isEmpty) {
      throw const AuthException();
    }
    final users = data['users'] as Map<String, dynamic>;
    final profile = users[username] as Map<String, dynamic>;
    return Session(
      username: username,
      displayName: profile['displayName'] as String,
      clientId: profile['clientId'] as int,
    );
  }

  @override
  Future<void> logout() async {
    await Future<void>.delayed(latency);
  }
}
