import 'package:flutter/material.dart';

// Add some routes name here ...
const mainRoute = '/main';
const loginRoute = '/login';
const registerRoute = '/register';
const forgotPasswordRoute = '/forgot-password';
const otpRoute = '/otp';
const resetPasswordRoute = '/reset-password';

// Register the RouteObserver as a navigation observer
final routeObserver = RouteObserver<ModalRoute<void>>();
