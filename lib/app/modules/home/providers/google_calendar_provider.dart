import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';

class GoogleCalendarProvider with GetLifeCycleBase {
  late final _googleSignIn = GoogleSignIn(scopes: [
    'email',
    CalendarApi.calendarScope,
    CalendarApi.calendarEventsScope,
  ], clientId: '624483477153-1o0d4sdi75mg76vu81q501fuduoafeob.apps.googleusercontent.com');
  late final Rxn<GoogleSignInAccount> _currentUser = Rxn();
  late final CalendarApi _calendarApi;
  void Function(GoogleSignInAccount account)? onUserAuthenticated;

  GoogleCalendarProvider({this.onUserAuthenticated});

  @override
  void onInit() {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      _currentUser.value = account;
      if (_currentUser.value != null) {
        _googleSignIn.authenticatedClient().then((client) {
          if (client != null) {
            _calendarApi = CalendarApi(client);
            onUserAuthenticated?.call(_currentUser.value!);
          }
        });
      }
    });
    _googleSignIn.signInSilently();
  }

  void handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (e, st) {
      print('$e\n$st');
    }
  }

  void handleSignOut() => _googleSignIn.disconnect();

  Future<CalendarList> getCalendarList() async => (await _calendarApi.calendarList.list());

  Future<CalendarListEntry> getCalendar(String calendarId, {String? $fields}) async =>
      await _calendarApi.calendarList.get(calendarId, $fields: $fields);

  Future<Events> getEvents(
    String calendarId, {
    bool? alwaysIncludeEmail,
    String? iCalUID,
    int? maxAttendees,
    int? maxResults,
    String? orderBy,
    String? pageToken,
    List<String>? privateExtendedProperty,
    String? q,
    List<String>? sharedExtendedProperty,
    bool? showDeleted,
    bool? showHiddenInvitations,
    bool? singleEvents,
    String? syncToken,
    DateTime? timeMax,
    DateTime? timeMin,
    String? timeZone,
    DateTime? updatedMin,
    String? $fields,
  }) async =>
      await _calendarApi.events.list(calendarId,
          alwaysIncludeEmail: alwaysIncludeEmail,
          iCalUID: iCalUID,
          maxAttendees: maxAttendees,
          maxResults: maxResults,
          orderBy: orderBy,
          pageToken: pageToken,
          privateExtendedProperty: privateExtendedProperty,
          q: q,
          sharedExtendedProperty: sharedExtendedProperty,
          showDeleted: showDeleted,
          showHiddenInvitations: showHiddenInvitations,
          singleEvents: singleEvents,
          syncToken: syncToken,
          timeMax: timeMax,
          timeMin: timeMin,
          timeZone: timeZone,
          updatedMin: updatedMin,
          $fields: $fields);

  Future<Event> getEvent(
    String calendarId,
    String eventId, {
    bool? alwaysIncludeEmail,
    int? maxAttendees,
    String? timeZone,
    String? $fields,
  }) async =>
      _calendarApi.events.get(calendarId, eventId,
          alwaysIncludeEmail: alwaysIncludeEmail, maxAttendees: maxAttendees, timeZone: timeZone, $fields: $fields);

  watchEvents(String calendarId, {Channel? request}) async =>
      await _calendarApi.events.watch(request ?? Channel(), calendarId);
}
