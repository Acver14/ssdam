import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:ssdam/customClass/reservatioin_info_class.dart';
import 'package:ssdam/firebase_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:ssdam/style/customColor.dart';
import 'file:///D:/AndroidProject/Flutter/ssdam/ssdam/lib/customWidget/reservation_button.dart';
import 'package:kopo/kopo.dart';
import 'package:popup_box/popup_box.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:ssdam/customWidget//time_picker_widget.dart';
import 'package:ssdam/customClass/time_picker_format_constant.dart';
import 'package:ssdam/customWidget/side_drawer.dart';
import 'package:ssdam/customWidget/loading_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';

SignedInPageState pageState;

final List<String>eventList = [
  'assets/event/event_demo.png'
];

class SignedInPage extends StatefulWidget {
  @override
  SignedInPageState createState() {
    pageState = SignedInPageState();
    return pageState;
  }
}

class SignedInPageState extends State<SignedInPage> {
  FirebaseProvider fp;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _getTrash = false;
  int _points;
  bool _loaded = false;
  TextEditingController detailAddressCont = TextEditingController();
  TextEditingController customerRequestCont = TextEditingController();
  ReservationInfoProvider reservationInfo = new ReservationInfoProvider();
  DateTime _date_time;
  var vh;
  var log = Logger();

  @override
  initState() {
    super.initState();
    getRememberAddr();
    getRememberRequests();
    DateTime tmpTime = DateTime.now();
    log.d('before: ${tmpTime}');
    if (tmpTime.hour > 8 && tmpTime.hour < 18) {
      if (tmpTime.hour == 18 && tmpTime.minute > 29) {
        _date_time =
            DateTime(tmpTime.year, tmpTime.month, tmpTime.day + 1, 9, 0, 0);
      } else {
        _date_time = tmpTime.add(Duration(minutes: 30));
      }
    } else if (tmpTime.hour > 17) {
      _date_time =
          DateTime(tmpTime.year, tmpTime.month, tmpTime.day + 1, 9, 0, 0);
    } else if (tmpTime.hour < 9) {
      _date_time =
          DateTime(tmpTime.year, tmpTime.month, tmpTime.day + 1, 9, 0, 0);
    }
    reservationInfo.setReservationTime(_date_time);
    log.d(_date_time);
    log.d(reservationInfo.getAddress());
  }

  getRememberAddr() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      reservationInfo.setAddress(prefs.getString("recentlyAddress") ?? "");
      reservationInfo
          .setDetailedAddress(prefs.getString("recentlyDetailedAddress") ?? "");
      reservationInfo.setCustomerRequests(
          prefs.getString("recentlyCustomerRequests") ?? "");
    });
  }

  getRememberRequests() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      reservationInfo.setCustomerRequests(
          prefs.getString("recentlyCustomerRequests") ?? "");
    });
  }

  setRememberAddr(String addr, String dAddr) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("recentlyAddress", addr ?? '');
    prefs.setString("recentlyDetailedAddress", dAddr ?? '');
  }

  setRememberRequests(String rq) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("recentlyCustomerRequests", rq ?? '');
  }

  Future<Map<String, dynamic>> Loading() async {
    Map<String, dynamic> _user_info = null;
    await fp.setUserInfo();
    _user_info = fp.getUserInfo();
    reservationInfo.setInitialInfo(
        fp.getUser().displayName, fp.getUser().uid, fp.getUser().email);
    if (_user_info != null) {
      return _user_info;
    }
  }

  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);
    reservationInfo.setInitialInfo(
        fp.getUser().displayName, fp.getUser().uid, fp.getUser().email);
    Constant.setTimeRange(9, 18);
    Constant.setMinuteRange(0, 59);
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    vh = MediaQuery.of(context).size.height;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar:AppBar(
            iconTheme: new IconThemeData(color: Colors.black),
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarOpacity: 1.0,
          ),

        drawer: sideDrawer(context, fp),
        body: Column(
                children: <Widget>[
                  //Container(height: 300, color: Colors.grey,),
                  CarouselSlider(
                    options: CarouselOptions(
                        height: 300.0,
                        reverse: true,
                        initialPage: 0,
                        autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                    ),
                    items: eventSliders,
                  ),
                  Divider(thickness: 5,),
                  Container(
                      margin: const EdgeInsets.only(top: 5, left: 30.0, right: 30.0),
                      child: Center(
                        child: Column(children: <Widget>[
                          Padding(padding: EdgeInsets.only(top: statusBarHeight)),
                          FutureBuilder(
                              future: Loading(),
                              builder:
                                  (BuildContext context, AsyncSnapshot snapshot) {
                                log.d(snapshot.data);
                                if (snapshot.hasData && !snapshot.data.isEmpty) {
                                  _getTrash = snapshot.data['getTrash?'];
                                  _points = snapshot.data['points'];
                                  return widgetContainerForReservation();
                                } else if (snapshot.hasError) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Error: ${snapshot.error}',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  );
                                } else {
                                  return widgetLoading();
                                }
                              }),
                          SizedBox(
                            height: 30,
                          ),
                          MaterialButton(
                            onPressed: reservationBtn,
                            color: COLOR_SSDAM,
                            textColor: Colors.white,
                            minWidth: 270.0,
                            height: 270.0,
                            child: Image.asset(
                              'assets/trash-icon.png',
                              width: 150.0,
                              height: 150.0,
                            ),
                            padding: EdgeInsets.all(16),
                            shape: CircleBorder(),
                          )
                        ]),
                      )
                  )
                ],),);
  }

  Widget widgetContainerForReservation() {
    return Column(
      children: <Widget>[
        ReservationButton(
          text: reservationInfo.getAddress().length != 0
              ? '${reservationInfo.getAddress()} ${reservationInfo.getDetailedAddress()}'
              : '어디로 가져다 드릴까요?',
          onPressed: () async {
            KopoModel model = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Kopo(),
              ),
            );
            print(model.toJson());
            if (model != null) {
              setState(() {
                reservationInfo.setAddress('${model.address}');
              });
              log.d("show?");
              await PopupBox.showPopupBox(
                  context: context,
                  button: MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.blue,
                    child: Text(
                      'Ok',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      reservationInfo
                          .setDetailedAddress(detailAddressCont.text.trim());
                      Navigator.of(context).pop();
                      setRememberAddr(
                          reservationInfo.getAddress(), detailAddressCont.text);
                    },
                  ),
                  willDisplayWidget: Column(
                    children: <Widget>[
                      Text(
                        '상세주소를 입력해주세요.\n(상세주소가 없을 경우 생략)',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      TextField(
                        controller: detailAddressCont,
                      )
                    ],
                  ));
            }
          },
        ), // input address
        ReservationButton(
            text: DateFormat('yyyy년 MM월 dd일 kk시 mm분').format(
                reservationInfo.getReservationTime() ?? DateTime.now().add(Duration(minutes: 30))),
            onPressed: () {
              showDatePicker(
                      context: context,
                      initialDate:
                      reservationInfo.getReservationTime() == null ? DateTime.now() : reservationInfo.getReservationTime(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 30)))
                  .then((date) {
                setState(() async {
                  _date_time = date;
                  log.d(_date_time);
                  var result = await TimePicker.pickTime(context,
                      selectedColor: Colors.amber,
                      nonSelectedColor: Colors.black,
                      displayType: DisplayType.bottomSheet,
                      timePickType: TimePickType.hourMinute,
                      buttonBackgroundColor: Colors.green,
                      title: "언제 가져다 드릴까요?",
                      fontSize: 24.0,
                      isTwelveHourFormat: false);
                  _date_time = _date_time.add(
                      Duration(hours: result.hour, minutes: result.minute));
                  setState(() {
                    reservationInfo.setReservationTime(_date_time);
                  });
                  log.d("예약 요청 시각 : ${reservationInfo.getReservationTime()}");
                });
              });
              setState((){});
            })
      ],
    );
  }

  Future<Widget> reservationBtn() async {
    await PopupBox.showPopupBox(
        context: context,
        button: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.blue,
          child: Text(
            'Ok',
            style: TextStyle(fontSize: 20),
          ),
          onPressed: () async {
            reservationInfo
                .setCustomerRequests(customerRequestCont.text.trim());
            Navigator.of(context).pop();
            setRememberRequests(reservationInfo.getCustomerRequests());
            reservationInfo.setApplicationTime(DateTime.now());
            if (fp.getUserInfo()["getTrash?"]) {
              if (_points > 10000) {
                if(reservationInfo.getAddress().length > 0){
                  await reservationInfo.saveReservationInfo("collect");
                  setState(() {
                    _points -= 10000;
                  });
                  Firestore.instance
                      .collection('userInfo')
                      .document(fp.getUser().email)
                      .updateData({"points": _points});
                  return PopupBox.showPopupBox(
                      context: context,
                      button: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Colors.blue,
                      ),
                      willDisplayWidget: Center(
                          child: Text(
                            '${fp.getUser().displayName}님\n${reservationInfo.getReservationTime()}\n 쓰레기통 교체 예약이 완료되었습니다.',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          )));
                }
                else{
                  return PopupBox.showPopupBox(
                      context: context,
                      button: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Colors.blue,
                      ),
                      willDisplayWidget: Center(
                          child: Text(
                            '주소 입력해주세요',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          )));
                }
              } else {
                return PopupBox.showPopupBox(
                    context: context,
                    button: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.blue,
                    ),
                    willDisplayWidget: Center(
                        child: Text(
                      '이용권 없어요 사세요',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    )));
              }
            } else {
              await reservationInfo.saveReservationInfo("deliver");
              setState(() {
                _getTrash = true;
              });
              Firestore.instance
                  .collection('userInfo')
                  .document(fp.getUser().email)
                  .updateData({"getTrash?": _getTrash});
              log.d('save to firestore');
              return PopupBox.showPopupBox(
                  context: context,
                  button: MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.blue,
                  ),
                  willDisplayWidget: Center(
                      child: Text(
                        '${fp.getUser().displayName}님\n${reservationInfo.getReservationTime()}\n 쓰레기통 배송 예약이 완료되었습니다.',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      )));
            }
          },
        ),
        willDisplayWidget: Column(
          children: <Widget>[
            Text(
              '요청 사항을 입력해주세요.\n(현관 비밀번호 등)',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            TextField(
              controller: customerRequestCont,
            )
          ],
        ));
  }



  final List<Widget> eventSliders = eventList.map((item) => Container(
    child: Container(
      margin: EdgeInsets.all(5.0),
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: FlatButton(
            child:Image.asset(item, fit: BoxFit.cover, width: 1000.0),
            onPressed: (){},
          )
      ),
    ),
  )).toList();
}
