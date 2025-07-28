import 'dart:async';
import 'package:pedometer/pedometer.dart';

class StepTrackerService {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;

  int _startSteps = 0;
  int _currentSteps = 0;
  String _status = 'Unknown';

  final StreamController<int> _stepsController = StreamController<int>.broadcast();
  final StreamController<String> _statusController = StreamController<String>.broadcast();

  Stream<int> get stepCountStream => _stepsController.stream;
  Stream<String> get statusStream => _statusController.stream;

  void init() {
    _stepCountStream = Pedometer.stepCountStream;
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;

    _stepCountStream.listen(_onStepCount).onError(_onStepCountError);
    _pedestrianStatusStream.listen(_onPedestrianStatusChanged).onError(_onPedestrianStatusError);
  }

  void _onStepCount(StepCount event) {
    if (_startSteps == 0) {
      _startSteps = event.steps;
    }
    _currentSteps = event.steps - _startSteps;
    _stepsController.sink.add(_currentSteps);
  }

  void _onStepCountError(error) {
    _stepsController.sink.addError('Step Count not available');
  }

  void _onPedestrianStatusChanged(PedestrianStatus status) {
    _status = status.status;
    _statusController.sink.add(_status);
  }

  void _onPedestrianStatusError(error) {
    _statusController.sink.addError('Pedestrian status not available');
  }

  void resetSteps() {
    _startSteps = _currentSteps + _startSteps;
    _currentSteps = 0;
    _stepsController.sink.add(_currentSteps);
  }

  void dispose() {
    _stepsController.close();
    _statusController.close();
  }
}
