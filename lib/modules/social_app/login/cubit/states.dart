
abstract class SocialLoginStates {}

class SocialLoginInitialState extends SocialLoginStates {}

class SocialLoginLoadingState extends SocialLoginStates {}

class SocialLoginSuccessState extends SocialLoginStates {
  final String uId;

  SocialLoginSuccessState(this.uId);
}

class SocialLoginErrorState extends SocialLoginStates
{
  final String error;

  SocialLoginErrorState(this.error);
}

class SocialRegisterLoadingState extends SocialLoginStates {}

class SocialRegisterSuccessState extends SocialLoginStates {}

class SocialRegisterErrorState extends SocialLoginStates
{
  final String error;

  SocialRegisterErrorState(this.error);
}

class SocialCreateUserSuccessState extends SocialLoginStates {
  final String uId;

  SocialCreateUserSuccessState(this.uId);
}

class SocialCreateUserErrorState extends SocialLoginStates
{
  final String error;

  SocialCreateUserErrorState(this.error);
}

class ChangePasswordVisibilityState extends SocialLoginStates {}