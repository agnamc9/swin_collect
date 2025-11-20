import 'package:flutter/material.dart';
import 'package:tax_collect/src/presentation/presentation.dart';
import '../../../main.dart';
import '../data/model/logout_event.dart';

class SessionObserver extends StatefulWidget {
  final Widget child;

  const SessionObserver({super.key, required this.child});

  @override
  State<SessionObserver> createState() => _SessionObserverState();
}

class _SessionObserverState extends State<SessionObserver> {
  @override
  void initState() {
    super.initState();
    eventBus.on<LogoutEvent>().listen((event) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SigninScreen()), (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
