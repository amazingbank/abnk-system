import '../../core/errors/app_exception.dart';
import '../models/identity.dart';
import '../repositories/identity_repository.dart';
import 'fixture_bundle.dart';

/// [IdentityRepository] 的 mock 实现——数据来自 `fixtures/identity.json`
/// （P0.3 种子快照：客户 A 过期 / 客户 B 有效）。
class MockIdentityRepository implements IdentityRepository {
  MockIdentityRepository({this.latency = const Duration(milliseconds: 250)});

  final Duration latency;

  @override
  Future<IdentityInfo> getIdentity(String username) async {
    await Future<void>.delayed(latency);
    final data = await FixtureBundle.load('identity.json');
    final raw = data[username];
    if (raw is! Map<String, dynamic>) {
      throw const ValidationException(code: ErrCodes.validationIdentityMissing);
    }
    return IdentityInfo.fromJson(raw);
  }
}
