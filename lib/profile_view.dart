import 'province.dart';
import 'ward.dart';
import 'district.dart';
import 'address_info.dart';
import 'user_info.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localstore/localstore.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final step1FormKey = GlobalKey<FormState>();
  final step2FormKey = GlobalKey<FormState>();

  int currentStep = 0;
  UserInfo userInfo = UserInfo();
  bool isloaded = false;

  Future<void> saveUserInfo(UserInfo info) async {
    return await Localstore.instance
        .collection('users')
        .doc('info')
        .set(info.toJson());
  }

  Future<Map<String, dynamic>?> loadUserInfo() async {
    return await Localstore.instance.collection('users').doc('info').get();
  }

  Future<UserInfo> init() async {
    if (isloaded) return userInfo;
    var value = await loadUserInfo();
    if (value != null) {
      try {
        isloaded = true;
        return UserInfo.fromJson(value);
      } catch (e) {
        debugPrint(e.toString());
        return UserInfo();
      }
    }
    return UserInfo();
  }

  @override
  Widget build(BuildContext context) {
    void updateStep(int value) {
      if (currentStep == 0) {
        if (step1FormKey.currentState!.validate()) {
          step1FormKey.currentState!.save();
          setState(() {
            currentStep = value;
          });
        }
      } else if (currentStep == 1) {
        if (value > currentStep) {
          if (step2FormKey.currentState!.validate()) {
            step2FormKey.currentState!.save();
            setState(() {
              currentStep = value;
            });
          }
        } else {
          setState(() {
            currentStep = value;
          });
        }
      } else if (currentStep == 2) {
        setState(() {
          if (value < currentStep) {
            currentStep = value;
          } else {
            saveUserInfo(userInfo).then((value) => {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Thông báo'),
                        content: const SingleChildScrollView(
                          child: ListBody(
                            children: [
                              Text('Hồ sơ người dùng đã được lưu thành công!'),
                              Text('Bạn có thể quay lại các bước để cập nhật'),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Đóng'),
                          )
                        ],
                      );
                    },
                  )
                });
          }
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cập nhật hồ sơ'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog<bool>(
                context: context,
                barrierDismissible: false, // người dùng phải nhấn nút!
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Xác nhận'),
                    content: const Text('Bạn có muốn xóa thông tin đã lưu?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Hủy'),
                        onPressed: () {
                          Navigator.of(context).pop(false); // đóng dialog
                        },
                      ),
                      TextButton(
                        child: const Text('Đồng ý'),
                        onPressed: () {
                          // thực hiện hành động khi người dùng chọn "Đồng ý"
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ],
                  );
                },
              ).then((value) {
                if (value != null && value == true) {
                  setState(() {
                    userInfo = UserInfo();
                    saveUserInfo(userInfo);
                  });
                }
              });
            },
            icon: const Icon(Icons.delete_outlined),
          ),
        ],
      ),
      body: FutureBuilder<UserInfo>(
        future: init(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            userInfo = snapshot.data!;
            return Stepper(
              type: StepperType.horizontal,
              currentStep: currentStep,
              controlsBuilder: (context, details) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      children: [
                        if (currentStep == 2)
                          FilledButton(
                            onPressed: details.onStepContinue,
                            child: const Text('LƯU'),
                          )
                        else
                          FilledButton.tonal(
                            onPressed: details.onStepContinue,
                            child: const Text('TIẾP'),
                          ),
                        if (currentStep > 0)
                          TextButton(
                            onPressed: details.onStepCancel,
                            child: const Text('Quay Lại'),
                          ),
                      ],
                    ),
                    if (currentStep == 2)
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text('Đóng'),
                      )
                  ],
                );
              },
              onStepTapped: (value) {
                updateStep(value);
              },
              onStepContinue: () {
                updateStep(currentStep + 1);
              },
              onStepCancel: () {
                if (currentStep > 0) {
                  setState(() {
                    currentStep--;
                  });
                }
              },
              steps: [
                Step(
                  title: const Text('Cơ bản'),
                  content: Step1Form(formKey: step1FormKey, userInfo: userInfo),
                  isActive: currentStep == 0,
                ),
                Step(
                  title: const Text('Địa chỉ'),
                  content: Step2Form(formKey: step1FormKey, userInfo: userInfo),
                  isActive: currentStep == 1,
                ),
                Step(
                  title: const Text('Xác nhận'),
                  content: ConfirmInfo(userInfo: userInfo),
                  isActive: currentStep == 2,
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else {
            return const Center(child: LinearProgressIndicator());
          }
        },
      ),
    );
  }
}

class Step1Form extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final UserInfo userInfo;
  const Step1Form({
    super.key,
    required this.formKey,
    required this.userInfo,
  });

  @override
  State<Step1Form> createState() => _Step1FormState();
}

class _Step1FormState extends State<Step1Form> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class Step2Form extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final UserInfo userInfo;
  const Step2Form({
    super.key,
    required this.formKey,
    required this.userInfo,
  });

  @override
  State<Step2Form> createState() => _Step2FormState();
}

class _Step2FormState extends State<Step2Form> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ConfirmInfo extends StatelessWidget {
  final UserInfo userInfo;
  const ConfirmInfo({super.key, required this.userInfo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInforItem('Họ và Tên:', userInfo.name),
          _buildInforItem(
              'Ngày sinh:',
              userInfo.birthday != null
                  ? DateFormat.yMMMd().format(userInfo.birthday)
                  : ''),
          _buildInforItem('Email', userInfo.email),
          _buildInforItem('Số điện thoại', userInfo.phoneNumber),
          _buildInforItem(
              'Tỉnh / Thành phố', userInfo.addressInfo.province.name),
          _buildInforItem('Huyện / Quận', userInfo.addressInfo.district.name),
          _buildInforItem(
              'Xã / Phường / Thị Trấn', userInfo.addressInfo.ward.name),
          _buildInforItem('Địa chỉ', userInfo.addressInfo.street),
        ],
      ),
    );
  }
}

Widget _buildInforItem(String lable, String? value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextField(
      readOnly: true,
      controller: TextEditingController(text: value),
      decoration: InputDecoration(
          labelText: lable,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.all(8)),
      style: const TextStyle(fontSize: 16),
    ),
  );
}
