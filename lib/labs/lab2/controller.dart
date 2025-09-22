import 'package:flutter/cupertino.dart';
import '../../model/lab.dart';
import 'api/iocontrol_service.dart';

class Lab2ControllerScreen extends StatefulWidget {
  final Lab lab;

  const Lab2ControllerScreen({super.key, required this.lab});

  @override
  State<Lab2ControllerScreen> createState() => _Lab2ControllerScreenState();
}

class _Lab2ControllerScreenState extends State<Lab2ControllerScreen> {
  static const String _board = 'iu9_shiyatov_mob';
  static const String _variable = 'controller';
  static const String _accessKey = '';

  late final IoControlService _service = IoControlService(
    board: _board,
    variable: _variable,
    accessKey: _accessKey,
  );

  late final IoControlService _polzService = IoControlService(
    board: _board,
    variable: 'polzunok',
    accessKey: _accessKey,
  );

  bool _isLoading = true;
  bool _isSaving = false;
  bool _controllerValue = false;
  String? _errorMessage;
  int _polzunokValue = 0;
  bool _isPolzSaving = false;

  @override
  void initState() {
    super.initState();
    _refreshAll();
  }

  Future<void> _refreshAll() async {
    await _fetchController();
    await _fetchPolzunok();
  }

  Future<void> _fetchController() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final int valueInt = await _service.readValue();
      setState(() {
        _controllerValue = valueInt == 1;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchPolzunok() async {
    try {
      final int valueInt = await _polzService.readValue();
      setState(() {
        _polzunokValue = valueInt;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _setController(bool newValue) async {
    setState(() {
      _isSaving = true;
      _errorMessage = null;
      _controllerValue = newValue;
    });
    final int valueInt = newValue ? 1 : 0;
    try {
      final int savedInt = await _service.setValue(valueInt);
      setState(() {
        _controllerValue = savedInt == 1;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _controllerValue = !newValue;
      });
      if (!mounted) return;
      _showToast(_errorMessage!);
    } finally {
      if (!mounted) return;
      setState(() {
        _isSaving = false;
      });
    }
  }

  Future<void> _setPolzunok(int newValue) async {
    setState(() {
      _isPolzSaving = true;
      _errorMessage = null;
      _polzunokValue = newValue;
    });
    try {
      final int savedInt = await _polzService.setValue(newValue);
      setState(() {
        _polzunokValue = savedInt;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
      if (mounted) {
        _showToast(_errorMessage!);
      }
      await _fetchPolzunok();
    } finally {
      if (!mounted) return;
      setState(() {
        _isPolzSaving = false;
      });
    }
  }

  Future<void> _incrementPolzunok() async {
    await _setPolzunok(_polzunokValue + 1);
  }

  Future<void> _decrementPolzunok() async {
    await _setPolzunok(_polzunokValue - 1);
  }

  Future<void> _resetPolzunok() async {
    await _setPolzunok(0);
  }

  void _showToast(String message) {
    showCupertinoDialog<void>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Ошибка'),
        content: Text(message),
        actions: <Widget>[
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            isDefaultAction: true,
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Лабораторная №${widget.lab.number}'),
        previousPageTitle: 'Назад',
      ),
      child: SafeArea(
        bottom: false,
        child: _isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: <Widget>[
                  CupertinoFormSection.insetGrouped(
                    header: const Text('Controller'),
                    children: <Widget>[
                      CupertinoFormRow(
                        prefix: const Text('Состояние'),
                        child: _isSaving
                            ? const CupertinoActivityIndicator()
                            : CupertinoSwitch(
                                value: _controllerValue,
                                onChanged: (v) => _setController(v),
                              ),
                      ),
                    ],
                  ),
                  CupertinoFormSection.insetGrouped(
                    header: const Text('Polzunok'),
                    children: <Widget>[
                      CupertinoFormRow(
                        prefix: const Text('Значение'),
                        child: Text(
                          '$_polzunokValue',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                      ),
                      CupertinoFormRow(
                        prefix: const Icon(CupertinoIcons.minus),
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerLeft,
                          onPressed: (!_controllerValue || _isPolzSaving) ? null : _decrementPolzunok,
                          child: const Text('Уменьшить'),
                        ),
                      ),
                      CupertinoFormRow(
                        prefix: const Icon(CupertinoIcons.add),
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerLeft,
                          onPressed: (!_controllerValue || _isPolzSaving) ? null : _incrementPolzunok,
                          child: const Text('Увеличить'),
                        ),
                      ),
                      CupertinoFormRow(
                        prefix: const Icon(CupertinoIcons.refresh),
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerLeft,
                          onPressed: (!_controllerValue || _isPolzSaving) ? null : _resetPolzunok,
                          child: const Text('Сбросить'),
                        ),
                      ),
                    ],
                  ),
                  if (_errorMessage != null)
                    CupertinoFormSection.insetGrouped(
                      header: const Text('Ошибка'),
                      children: <Widget>[
                        CupertinoFormRow(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: CupertinoColors.systemRed),
                          ),
                        ),
                      ],
                    ),
                  CupertinoFormSection.insetGrouped(
                    children: <Widget>[
                      CupertinoFormRow(
                        prefix: const Icon(CupertinoIcons.refresh),
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerLeft,
                          onPressed: _isLoading ? null : _refreshAll,
                          child: const Text('Обновить состояние'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}


