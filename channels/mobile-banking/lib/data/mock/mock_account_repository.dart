import '../../core/errors/app_exception.dart';
import '../models/account.dart';
import '../models/transaction.dart';
import '../repositories/account_repository.dart';
import 'fixture_bundle.dart';

/// [AccountRepository] 的 mock 实现。
///
/// 首次访问从 `fixtures/accounts.json` + `fixtures/transactions.json` 加载
/// 种子快照并驻留内存；转账 / 定期开户会更新内存态（余额变动 + 新流水），
/// 演示「交易成功 → 明细出现新流水」的完整闭环（对齐旅程 Step 8 口径）。
class MockAccountRepository implements AccountRepository {
  MockAccountRepository({this.latency = const Duration(milliseconds: 400)});

  final Duration latency;

  final Map<String, _Ledger> _ledgers = {};
  final Map<int, List<TransactionItem>> _transactionsByAccount = {};
  final Map<int, Account> _accountsById = {};
  int _nextTxnId = 100;
  int _nextFdAccountId = 200;

  // ── 内部状态装载 ────────────────────────────────────────────

  Future<_Ledger> _ledger(String username) async {
    final cached = _ledgers[username];
    if (cached != null) return cached;
    final accountsData = await FixtureBundle.load('accounts.json');
    final txData = await FixtureBundle.load('transactions.json');
    final raw = accountsData[username];
    if (raw is! Map<String, dynamic>) {
      throw const ValidationException('未找到账户信息');
    }
    final savings = (raw['savingsAccounts'] as List)
        .whereType<Map<String, dynamic>>()
        .map(Account.fromJson)
        .toList();
    final fixed = (raw['fixedDepositAccounts'] as List)
        .whereType<Map<String, dynamic>>()
        .map(Account.fromJson)
        .toList();
    final ledger =
        _Ledger(savingsAccounts: savings, fixedDepositAccounts: fixed);
    _ledgers[username] = ledger;
    for (final account in [...savings, ...fixed]) {
      _accountsById[account.id] = account;
      final rawTx = txData['${account.id}'];
      final txList = (rawTx is List ? rawTx : const [])
          .whereType<Map<String, dynamic>>()
          .map(TransactionItem.fromJson)
          .toList();
      _transactionsByAccount[account.id] = txList;
    }
    return ledger;
  }

  Account _account(int id) {
    final account = _accountsById[id];
    if (account == null) {
      throw ValidationException('账户 $id 不存在');
    }
    return account;
  }

  void _appendTransaction(
    int accountId,
    String type,
    double amount,
    String? note,
  ) {
    final list = _transactionsByAccount.putIfAbsent(accountId, () => []);
    final account = _account(accountId);
    final newBalance = type == 'Deposit'
        ? account.accountBalance + amount
        : account.accountBalance - amount;
    _accountsById[accountId] = account.copyWith(
      accountBalance: newBalance,
      availableBalance: newBalance,
    );
    _ledgers.updateAll(
      (_, ledger) => ledger..refreshFrom(_accountsById),
    );
    list.insert(
      0,
      TransactionItem(
        id: _nextTxnId++,
        date: _today(),
        transactionType: type,
        amount: amount,
        runningBalance: newBalance,
        note: note,
      ),
    );
  }

  static String _today() {
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }

  /// 对年对月对日到期（P0.2 实测口径：激活日 + N 个月，日 Clamp 到月末）。
  static String _maturityAfterMonths(int months) {
    final now = DateTime.now();
    var year = now.year;
    var month = now.month + months;
    year += (month - 1) ~/ 12;
    month = (month - 1) % 12 + 1;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final day = now.day > daysInMonth ? daysInMonth : now.day;
    final mm = month.toString().padLeft(2, '0');
    final dd = day.toString().padLeft(2, '0');
    return '$year-$mm-$dd';
  }

  // ── 接口实现 ────────────────────────────────────────────────

  @override
  Future<AccountSummary> getAccounts(String username) async {
    await Future<void>.delayed(latency);
    final ledger = await _ledger(username);
    return AccountSummary(
      savingsAccounts:
          ledger.savingsAccounts.map((a) => _accountsById[a.id]!).toList(),
      fixedDepositAccounts:
          ledger.fixedDepositAccounts.map((a) => _accountsById[a.id]!).toList(),
    );
  }

  @override
  Future<List<TransactionItem>> getTransactions(int accountId) async {
    await Future<void>.delayed(latency);
    await _ledgerAny();
    final list = _transactionsByAccount[accountId];
    if (list == null) {
      throw ValidationException('账户 $accountId 不存在');
    }
    return List.unmodifiable(list);
  }

  Future<void> _ledgerAny() async {
    if (_ledgers.isNotEmpty) return;
    final data = await FixtureBundle.load('accounts.json');
    final username = (data.keys
            .where((k) => !k.startsWith('_') && k != 'demoUsers'))
        .first;
    await _ledger(username);
  }

  @override
  Future<TransferResult> transfer(TransferRequest request) async {
    await Future<void>.delayed(latency);
    await _ledgerAny();
    final from = _account(request.fromAccountId);
    final to = _account(request.toAccountId);
    if (request.fromAccountId == request.toAccountId) {
      throw const ValidationException('转出与转入账户不能相同');
    }
    if (request.amount <= 0) {
      throw const ValidationException('转账金额必须大于 0');
    }
    if (request.amount > from.availableBalance) {
      throw const ValidationException('余额不足');
    }
    _appendTransaction(
      from.id,
      'Withdrawal',
      request.amount,
      request.note ?? '本人账户转账',
    );
    _appendTransaction(
      to.id,
      'Deposit',
      request.amount,
      request.note ?? '本人账户转账',
    );
    return TransferResult(
      transactionId: _nextTxnId - 2,
      newSourceBalance: _account(from.id).accountBalance,
    );
  }

  @override
  Future<FixedDepositResult> openFixedDeposit(
      FixedDepositRequest request) async {
    await Future<void>.delayed(latency);
    await _ledgerAny();
    final productsData = await FixtureBundle.load('loan_products.json');
    final rawProducts = (productsData['fixedDepositProducts'] as List)
        .whereType<Map<String, dynamic>>();
    final product = rawProducts
        .where((p) => p['id'] == request.productId)
        .firstOrNull;
    if (product == null) {
      throw ValidationException('定期产品 ${request.productId} 不存在');
    }
    final source = _account(request.sourceAccountId);
    if (request.amount <= 0) {
      throw const ValidationException('存入金额必须大于 0');
    }
    if (request.amount < (product['minDepositAmount'] as num).toDouble()) {
      throw ValidationException('低于起存金额');
    }
    if (request.amount > source.availableBalance) {
      throw const ValidationException('余额不足');
    }

    final depositPeriod = product['depositPeriod'] as int;
    final newAccountId = _nextFdAccountId++;
    _appendTransaction(source.id, 'Withdrawal', request.amount, '定期开户');
    final newAccount = Account(
      id: newAccountId,
      accountNo: '0000**0$newAccountId',
      productName: product['name'] as String,
      accountType: AccountType.fixedDeposit,
      currency: 'CNY',
      accountBalance: request.amount,
      availableBalance: 0,
      status: 'ACTIVE',
      interestRate: (product['interestRate'] as num).toDouble(),
      maturityDate: _maturityAfterMonths(depositPeriod),
    );
    _accountsById[newAccountId] = newAccount;
    _transactionsByAccount[newAccountId] = [];
    _ledgers.updateAll(
      (_, ledger) => ledger..fixedDepositAccounts.add(newAccount),
    );
    return FixedDepositResult(
      accountId: newAccountId,
      maturityDate: newAccount.maturityDate!,
    );
  }
}

/// 单用户的内存账本（活期 + 定期账户引用）。
class _Ledger {
  _Ledger({required this.savingsAccounts, required this.fixedDepositAccounts});

  List<Account> savingsAccounts;
  List<Account> fixedDepositAccounts;

  /// 账户对象在内存中被 copyWith 替换后，同步引用。
  void refreshFrom(Map<int, Account> accountsById) {
    savingsAccounts = savingsAccounts
        .map((a) => accountsById[a.id] ?? a)
        .toList();
    fixedDepositAccounts = fixedDepositAccounts
        .map((a) => accountsById[a.id] ?? a)
        .toList();
  }
}
