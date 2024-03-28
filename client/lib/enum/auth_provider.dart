
enum AuthProvider {

  unknown,

  // Only for debug version
  dev,
  devWithKey,

  // secret - OAuth2: jwt idToken.subject
  google,

  // secret - AppleIDCredential.user
  apple;

  String toQuery() {
    return (this == devWithKey ? dev : this).name;
  }

}