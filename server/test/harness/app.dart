import 'package:aqueduct_test/aqueduct_test.dart';
import 'package:lapse_server/lapse_server.dart';

export 'package:aqueduct/aqueduct.dart';
export 'package:aqueduct_test/aqueduct_test.dart';
export 'package:lapse_server/lapse_server.dart';
export 'package:test/test.dart';

/// A testing harness for lapse_server.
///
/// A harness for testing an aqueduct application. Example test file:
///
///         void main() {
///           Harness harness = Harness()..install();
///
///           test("GET /path returns 200", () async {
///             final response = await harness.agent.get("/path");
///             expectResponse(response, 200);
///           });
///         }
///
class Harness extends TestHarness<LapseServerChannel> with TestHarnessORMMixin {
  @override
  Future onSetUp() async {
    await resetData();
  }

  // TODO: implement context
  @override
  ManagedContext get context => channel.context;
}
