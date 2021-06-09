import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:meetup/constants/app_routes.dart';
import 'package:meetup/requests/auth.request.dart';
import 'package:meetup/services/auth.service.dart';
import 'base.view_model.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:meetup/translations/dialogs.i18n.dart';

class RegisterViewModel extends MyBaseViewModel {
  //
  AuthRequest _authRequest = AuthRequest();

  //the textediting controllers
  TextEditingController nameTEC = new TextEditingController();
  TextEditingController emailTEC = new TextEditingController();
  TextEditingController phoneTEC = new TextEditingController();
  TextEditingController passwordTEC = new TextEditingController();

  RegisterViewModel(BuildContext context) {
    this.viewContext = context;
  }

  void processRegister() async {
    // Validate returns true if the form is valid, otherwise false.
    if (formKey.currentState.validate()) {
      //
      //

      setBusy(true);

      final apiResponse = await _authRequest.registerRequest(
        name: nameTEC.text,
        email: emailTEC.text,
        phone: phoneTEC.text,
        password: passwordTEC.text,
      );

      setBusy(false);

      if (apiResponse.hasError()) {
        //there was an error
        CoolAlert.show(
          context: viewContext,
          type: CoolAlertType.error,
          title: "Registration Failed".i18n,
          text: apiResponse.message,
        );
      } else {
        //everything works well
        await AuthServices.saveUser(apiResponse.body["user"]);
        await AuthServices.setAuthBearerToken(apiResponse.body["token"]);
        await AuthServices.isAuthenticated();
        viewContext.navigator.pushNamedAndRemoveUntil(
          AppRoutes.homeRoute,
          (_) => false,
        );
      }
    }
  }

  void openLogin() async {
    viewContext.pop();
  }
}
