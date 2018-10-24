import 'lapse_server.dart';
import 'model/lapse.dart';
import 'model/user.dart';

/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://aqueduct.io/docs/http/channel/.
class LapseServerChannel extends ApplicationChannel {
  AuthServer authServer;
  ManagedContext context;

  /// Initialize services in this method.
  ///
  /// Implement this method to initialize services, read values from [options]
  /// and any other initialization required before constructing [entryPoint].
  ///
  /// This method is invoked prior to [entryPoint] being accessed.
  @override
  Future prepare() async {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));

    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final psc = PostgreSQLPersistentStore.fromConnectionInfo(
        "lapse_server_user", "password", "localhost", 5432, "lapse_server");

    context = ManagedContext(dataModel, psc);

    final authStorage = ManagedAuthDelegate<User>(context);
    authServer = AuthServer(authStorage);
  }

  /// Construct the request channel.
  ///
  /// Return an instance of some [Controller] that will be the initial receiver
  /// of all [Request]s.
  ///
  /// This method is invoked after [prepare].
  @override
  Controller get entryPoint {
    final router = Router();

    router
      .route("/auth/register")
      .link(() => AuthCodeController(authServer));

    router
        .route("/auth/token")
        .link(() => AuthController(authServer));

    router
        .route("/lapses/[:id]")
//        .link(() => Authorizer.bearer(authServer))
        .link(() => ManagedObjectController<Lapse>(context));

    return router;
  }
}