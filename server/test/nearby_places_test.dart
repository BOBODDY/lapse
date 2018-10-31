import 'package:lapse_server/model/user.dart';

import 'harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  const testUsername = "test";
  const testPassword = "password";

  final testUser = User()
    ..username = testUsername
    ..password = testPassword;

  Agent agent;

  setUp(() async {
    agent =
        await harness.registerUser(testUser, withClient: harness.publicAgent);
  });

  tearDown(() async {
    await harness.resetData();
  });

  await harness.loginUser(agent, testUsername, testPassword);

  test("GET /nearby returns empty list", () async {
    expectResponse(await agent.request("/lapses/nearby").get(), 200,
        body: isEmpty);

    var postRequest = agent.request("/lapses")
      ..body = {
        "latitude": 37.3660,
        "longitude": -84.1234,
        "description": "My first place"
      };
    expectResponse(await postRequest.post(), 200);

    final request = agent.request("/lapses/nearby?lat=37.368,long=-84.1232");
    expect(await request.post(), hasBody(isNotEmpty));
  });
}
