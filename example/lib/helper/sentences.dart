class Sentences{

  // Page titles
  static String title() => "test";
  static String appTitle() => "C Messaging";
  static String homePageTitle() => "C Messaging";
  static String mainPageTitle() => "Main Page";
  static String contactsPageTitle() => "Contacts";

  // General words
  static String ok()=> "OK";
  static String accept()=> "Accept";
  static String confim()=> "Confirm";
  static String cancel()=> "Cancel";
  static String send()=> "Send";

  // Validator warning sentences
  static String pleaseEnterEmail()=> "Please enter your e-mail address";
  static String pleaseEnterValidEmail()=> "Please enter a valid e-mail address";
  static String pleaseEnterNameSurname()=> "Please enter your name and surname";
  static String pleaseEnterPassword()=> "Please enter your password";
  static String pleaseEnterPasswordAgain()=> "Please enter your password again";
  static String passwordsNotMatch()=> "Passwords do not match";
  static String nameSurnameShort(int min)=> "Name surname cannot be shorter than $min characters";
  static String nameSurnameLong(int max)=> "Name surname cannot be longer than $max characters";
  static String passwordShort(int min)=> "Password cannot be shorter than $min characters";
  static String passwordLong(int max)=> "Password cannot be longer than $max characters";
  static String phoneShort(int min)=> "Phone number cannot be shorter than $min characters";
  static String phoneLong(int max)=> "Phone number cannot be longer than $max characters";
  static String phoneShouldBeNumeric()=> "Phone number must be numeric";

  // Error sentences
  static String errorTryAgain()=> "An error occured; please try again";
  static String errorUserNotFound()=> "There is no account linked with this email address";
  static String errorWrongPassword()=> "Password is wrong";
  static String errorEmailAlreadyInUse()=> "There is already an account linked with this email address";

  // Loading dialog texts
  static String signingIn()=> "Signing in...";
  static String registering()=> "Registering...";
  static String uploadingImage()=> "Uploading Image...";
  static String sendingPasswordResetEmail()=> "Sending e-mail; please wait";
  static String updating() => "Updating..." ;

  // Login Page
  static String login() => "Login";
  static String email() => "Email";
  static String password() => "Password";
  static String forgotPassword() => "Forgot password?";
  static String resetPassword() => "Reset Password";
  static String singInWithGoogle() => "Sign in with Google";
  static String registerIfNoAccount() => "Don't you have an account? Register";
  static String passwordResetEmailSentSuccessfully()=> "Password reset email has been sent to your email address";

  // Register Page
  static String register() => "Register";
  static String nameSurname() => "Name Surname";
  static String phoneNumber() => "Phone Number";
  static String passwordAgain() => "Password (Again)";
  static String loginIfHaveAccount() => "Already have an account? Login";

  // Messages Page
  static String typeMessage()=> "Type a message";

  // Profile Page
  static String profileUpdated() => "Profile has been updated successfully";
  static String profileNotChanged() => "There is no change detected";

  // Logout
  static String logout()=> "Logout";
  static String logoutConfirm()=> "Do you want to logout?";

  // Delete
  static String deleteAllMessages()=> "Delete Messages";
  static String deleteAllMessagesConfirm()=> "All messages from this user will be deleted. Do you accept?";
  static String deleteMessage()=> "Delete Message";
  static String deleteMessageConfirm()=> "This message will be deleted. Do you accept?";

  // Photo choosing
  static String takePhoto()=> "Take a photo";
  static String chooseFromGallery()=> "Choose from gallery";
}