import 'harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  // TODO setup all data

  test("GET /lapses/nearby returns empty list", () async {
    expectResponse(await harness.agent.request("/lapses/nearby").get(), 200,
        body: isEmpty);
  });

  var postRequest = harness.agent.request("/lapses");
  postRequest.body = {
    "latitude": 37.3660,
    "longitude": -84.1234,
    "description": "My first place"
  };
  await postRequest.post();

  test("GET /lapses/nearby returns 1", () async {
    var request = harness.agent.request("/lapses/nearby");
    request.body = {"_latitude": 37.3662, "_longitude": -84.123};
    expect(await request.post(), hasBody(isNotEmpty));
  });
}
