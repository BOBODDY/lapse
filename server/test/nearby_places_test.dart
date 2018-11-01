import 'harness/app.dart';

Future main() async {
  final harness = Harness()..install();

//  const testUsername = "test";
//  const testPassword = "password";
//
//  final testUser = User()
//    ..username = testUsername
//    ..password = testPassword;
//
//  Agent agent;
//
//  setUp(() async {
//    agent =
//        await harness.registerUser(testUser, withClient: harness.publicAgent);
//  });

  tearDown(() async {
    await harness.resetData();
  });

  const testLocation = "?lat=33.7490&long=-84.3880";

  final northIncluded = {
    "latitude": 34.0617,
    "longitude": -84.3880,
    "description": "North included"
  };
  final southIncluded = {
    "latitude": 33.4363,
    "longitude": -84.3880,
    "description": "South included"
  };
  final eastIncluded = {
    "latitude": 33.7490,
    "longitude": -83.9932,
    "description": "East included"
  };
  final westIncluded = {
    "latitude": 33.7490,
    "longitude": -84.7828,
    "description": "West included"
  };

  final excluded = {
    "latitude": 35.1234,
    "longitude": -80.4321,
    "description": "Far far away"
  };

//  await harness.loginUser(agent, testUsername, testPassword);

  test("GET /nearby returns empty list", () async {
    expectResponse(
        await harness.agent.request("/nearby$testLocation").get(), 200,
        body: isEmpty);

    await harness.agent.post("/lapses", body: northIncluded);
    await harness.agent.post("/lapses", body: eastIncluded);
    await harness.agent.post("/lapses", body: southIncluded);
    await harness.agent.post("/lapses", body: westIncluded);
    await harness.agent.post("/lapses", body: excluded);

    final request = harness.agent.request("/nearby$testLocation");
    expectResponse(await request.get(), 200, body: hasLength(4));
  });
}
