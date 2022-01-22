import 'package:my_app/twiddar/twiddar.dart';

import './twiddar_base.dart';

class Users {
  final UserLookup userLookup;
  final Follows follows;
  final Blocks blocks;
  Users(TwiddarClient client)
      : userLookup = UserLookup(client),
        follows = Follows(client),
        blocks = Blocks(client);
}

class UserLookup extends TwiddarServiceBase {
  UserLookup(TwiddarClient client) : super(client);

  Future<TwiddarResponse> retrieveMultipleUsersWithIDs(queryParameters) async =>
      this.client.twiddarApiGet('/users', queryParameters);

  Future<TwiddarResponse> retrieveSingleUserWithID(
          userid, queryParameters) async =>
      this.client.twiddarApiGet('/users/$userid', queryParameters);

  Future<TwiddarResponse> retrieveMultipleUsersWithUsernames(
          queryParameters) async =>
      this.client.twiddarApiGet('/users/by', queryParameters);

  Future<TwiddarResponse> retrieveSingleUserWithUsername(
          username, queryParameters) async =>
      this
          .client
          .twiddarApiGet('/users/by/username/$username', queryParameters);
}

class Follows extends TwiddarServiceBase {
  Follows(TwiddarClient client) : super(client);

  Future<TwiddarResponse> lookupFollowingOfAUserBID(
          userid, queryParameters) async =>
      this.client.twiddarApiGet('/users/$userid/following', queryParameters);

  Future<TwiddarResponse> lookupFollowersOfAUserByID(
          userid, queryParameters) async =>
      this.client.twiddarApiGet('/users/$userid/followers', queryParameters);
}

class Blocks extends TwiddarServiceBase {
  Blocks(TwiddarClient client) : super(client);

  Future<TwiddarResponse> lookupBlockedUserWithUserId(
          userid, queryParameters) async =>
      this.client.twiddarApiGet('/users/$userid/blocking', queryParameters);
}
