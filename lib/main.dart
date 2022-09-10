


void main() {
  final isValid = validate(email: "email", password: "password");
  if (isValid == null) {
    login(email: "email", password: "password");
  } 
}

void login({
  required String email,
  required String password,
}) {}

String? validate({String? email,  String? password}) {
  final emailIsValid = validateEmail(email);
  final passwordIsValid = validatePassword(password);

  if (passwordIsValid == false) {
    return "A senha está errada";
  }
  if (emailIsValid == false) {
    return "Email está errado";
  }

  return "Sucesso";
}

bool validateEmail(String? email) => email != null && email.length > 0;
bool validatePassword(String? password) => password != null && password.length > 8;

void validateLogin({required String email, required String password}) {
  print("Conectando");
  print("Login sucesso");

}