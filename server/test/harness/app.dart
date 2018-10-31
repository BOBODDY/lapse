import 'package:aqueduct_test/aqueduct_test.dart';
import 'package:lapse_server/lapse_server.dart';
import 'package:lapse_server/model/user.dart';

export 'package:aqueduct/aqueduct.dart';
export 'package:aqueduct_test/aqueduct_test.dart';
export 'package:lapse_server/lapse_server.dart';
export 'package:test/test.dart';

/// A testing harness for lapse_server.
///
/// A harness for testing an aqueduct application.
///
class Harness extends TestHarness<LapseServerChannel>
    with TestHarnessAuthMixin<LapseServerChannel>, TestHarnessORMMixin {
  Agent publicAgent;

  @override
  Future onSetUp() async {
    await resetData();
    publicAgent = await addClient("com.mathewsmobile.mapping");
  }

  Future<Agent> registerUser(User user, {Agent withClient}) async {
    withClient ??= publicAgent;

    final req = withClient.request("/auth/register")
      ..body = {"username": user.username, "password": user.password};
    await req.post();

    return loginUser(withClient, user.username, user.password);
  }

  @override
  ManagedContext get context => channel.context;

  @override
  AuthServer get authServer => channel.authServer;
}
