import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import '../data/api/api_client.dart';
import '../model/register_model.dart';
import '../model/response_model.dart';
import '../utils/my_helper.dart';

class AuthController extends GetxController {
  var isPasswordHidden = true.obs;

  ApiClient apiClient;

  AuthController({required this.apiClient});

  @override
  void onInit() {
    isPasswordHidden.value = true;
    super.onInit();
  }

  Future<String> getDeviceId() async {
    String deviceId = 'Loading...';
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    try {
      if (Platform.isIOS) {
        IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
        deviceId = iosDeviceInfo.identifierForVendor ?? '';
      } else if (Platform.isAndroid) {
        AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
        deviceId = androidDeviceInfo.id;
      }
      return deviceId;
    } catch (e) {
      return deviceId;
    }
  }

  //check email validation
  bool isEmailValid(String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  void updateError() {
    _isLoading = false;
    update();
  }

  bool _isLoading = false;

  bool _isLoadingResend = false;

  final _isEditing = false.obs;
  final _isEditingPhone = false.obs;

  bool get isLoading => _isLoading;

  RxBool get isEditing => _isEditing;

  RxBool get isEditingPhone => _isEditingPhone;

  void changeEditItem(bool isName) {
    if (isName) {
      _isEditing.value = !_isEditing.value;
    } else {
      _isEditingPhone.value = !_isEditingPhone.value;
    }
    update();
  }

  bool get isLoadingResend => _isLoadingResend;

  Future<ResponseModel> registration(
      String name, String email, String password, String phoneNum) async {
    _isLoading = true;
    update();
    String deviceId = await getDeviceId();
    Response response = await registrationClient(
      name: name,
      email: email,
      password: password,
      deviceId: deviceId,
      phoneNum: phoneNum,
    );
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      RegisterModel registerModel = registerModelFromJson(response.body);
      saveUserToken(registerModel.data?.accessToken ?? '');
      responseModel = ResponseModel(true, response.body);
    } else {
      responseModel = ResponseModel(false, response.body);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> login(String? email, String password) async {
    _isLoading = true;
    update();
    Response response = await loginClient(email: email, password: password);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      RegisterModel registerModel = registerModelFromJson(response.body);
      saveUserToken(registerModel.data?.accessToken ?? '');
      responseModel = ResponseModel(true, response.body);
    } else {
      responseModel = ResponseModel(false, response.body, response.statusCode);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> updateProfile(
      String name, String phone, String email) async {
    _isLoading = true;
    update();
    Response response =
        await updateProfileClient(name: name, phone: phone, email: email);
    ResponseModel responseModel;
    Response1Model response1model = response1ModelFromJson(response.body);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response1model.message);
    } else {
      responseModel = ResponseModel(
          false, response1model.message, response.statusCode);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> sendOtp(String? email,
      {String? otp, bool? isResend = false}) async {
    if (isResend!) {
      _isLoadingResend = true;
    } else {
      _isLoading = true;
    }
    update();
    Response response;
    if (otp != null) {
      response = await verifyOtpClient(email: email, otp: otp);
    } else {
      response = await sendOtpClient(email: email);
    }
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body);
    } else {
      responseModel = ResponseModel(false, response.body);
    }
    if (isResend) {
      _isLoadingResend = false;
    } else {
      _isLoading = false;
    }
    update();
    return responseModel;
  }

  Future<ResponseModel> changePassword(
      String email,String otp, String password, String confirmPassword) async {
    _isLoading = true;
    update();
    Response response = await changePasswordClient(
        email: email,otp: otp, password: password, confirmPassword: confirmPassword);
    ResponseModel responseModel;
    Response1Model response1model = response1ModelFromJson(response.body);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response1model.message);
    } else {
      responseModel = ResponseModel(false, response.body);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<Response> registrationClient(
      {String? email,
      String? name,
      String? password,
      String? deviceId,
      String? phoneNum}) async {
    return await apiClient.postData(MyHelper.registerUrl, {
      "name": name,
      "email": email,
      "password": password,
      "device_id": deviceId,
      "phone": phoneNum,
    });
  }

  Future<Response> loginClient({String? email, String? password}) async {
    String deviceId = await getDeviceId();
    return await apiClient.postData(MyHelper.loginUrl,
        {"email": email, "password": password, "device_id": deviceId},
        isLogin: true);
  }

  Future<Response> updateProfileClient(
      {String? name, String? phone, String? email}) async {
    return await apiClient.postData(MyHelper.updateProfile,
        {"name": name, "phone": phone, "email": email});
  }

  Future<Response> sendOtpClient({String? email}) async {
    return await apiClient.postData(MyHelper.sendOtpUrl, {"email": email});
  }

  Future<Response> verifyOtpClient({String? email, String? otp}) async {
    return await apiClient
        .postData(MyHelper.verifyOtpUrl, {"email": email, "otp": otp});
  }

  Future<Response> changePasswordClient(
      {String? email,
      String? otp,
      String? password,
      String? confirmPassword}) async {
    return await apiClient.postData(MyHelper.changePasswordUrl, {
      "email": email,
      "otp": otp,
      "password": password,
      "password_confirmation": confirmPassword
    });
  }

  Future<void> saveUserToken(String token) async {
    GetStorage().write(MyHelper.bToken, token);
    apiClient.updateHeader(isToken: true);
  }

  Future<ResponseModel> updatePaymentDetails(String? rawBody) async {
    Response response = await updatePaymentDetailsClient(rawData: rawBody);
    ResponseModel responseModel;
    Response1Model response1model = response1ModelFromJson(response.body);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response1model.message);
    } else if (response.statusCode == 405 || response.statusCode == 401) {
      return ResponseModel(false, "Unauthenticated", response.statusCode);
    } else {
      responseModel = ResponseModel(
          false, response1model.message, response.statusCode);
    }
    return responseModel;
  }

  Future<Response> updatePaymentDetailsClient({String? rawData}) async {
    return await apiClient.postData(MyHelper.savePaymentInfoUrl, rawData,
        isRaw: true);
  }

  Future<ResponseModel> saveFlutterwavePayment(String? rawBody) async {
    Response response = await saveFlutterwavePaymentClient(rawData: rawBody);
    ResponseModel responseModel;
    Response1Model response1model = response1ModelFromJson(response.body);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response1model.message);
    } else if (response.statusCode == 405 || response.statusCode == 401) {
      return ResponseModel(false, "Unauthenticated", response.statusCode);
    } else {
      responseModel = ResponseModel(
          false, response1model.message, response.statusCode);
    }
    return responseModel;
  }

  Future<Response> saveFlutterwavePaymentClient({String? rawData}) async {
    return await apiClient.postData(MyHelper.flutterwavePaymentUrl, rawData,
        isRaw: true);
  }
}
