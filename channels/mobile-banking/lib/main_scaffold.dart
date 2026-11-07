import 'package:flutter/material.dart';

import 'features/home/home_page.dart';
import 'features/loans/loans_page.dart';
import 'features/profile/profile_page.dart';
import 'features/transactions/transactions_page.dart';

/// 登录后的主脚手架——底部导航四页签（首页 / 明细 / 贷款 / 我的）。
class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // 首页/明细用页签序号作 key——每次切回该页签重建并重新拉取
          // mock 内存态（转账/开户后的余额与新流水即时可见，对齐旅程 Step 8）。
          KeyedSubtree(
            key: ValueKey('home-$_currentIndex'),
            child: HomePage(onNavigateTab: (i) => setState(() => _currentIndex = i)),
          ),
          KeyedSubtree(
            key: ValueKey('tx-$_currentIndex'),
            child: const TransactionsPage(),
          ),
          const LoansPage(),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: '首页',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: '明细',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_outlined),
            selectedIcon: Icon(Icons.account_balance),
            label: '贷款',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: '我的',
          ),
        ],
      ),
    );
  }
}
