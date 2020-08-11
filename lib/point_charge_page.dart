import 'package:flutter/material.dart';
import 'package:ssdam/customWidget/side_drawer.dart';
import 'package:ssdam/firebase_provider.dart';
import 'package:provider/provider.dart';
import 'package:ssdam/style/customColor.dart';
import 'firebase_provider.dart';
import 'package:ssdam/customWidget/point_charge_button.dart';
import 'package:ssdam/style/textStyle.dart';
import 'package:ssdam/payment_management/bootpay_payapp.dart';
import 'package:ssdam/payment_management/iamport_inicis.dart';

PointChargePageState pageState;

class PointChargePage extends StatefulWidget {
  @override
  PointChargePageState createState() {
    pageState = PointChargePageState();
    return pageState;
  }
}

class PointChargePageState extends State<PointChargePage>{
  FirebaseProvider fp;
  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);
    return Scaffold(
      drawer: sideDrawer(context, fp),
        appBar: AppBar(
          title: Text('포인트 충전', style: TextStyle(color: Colors.black)),
          iconTheme: new IconThemeData(color: Colors.black),
          backgroundColor: Colors.white.withOpacity(0.0),
          elevation: 0,
          toolbarOpacity: 1.0,
        ),
        body: Column(
          children: <Widget>[
            Text('정기 결제', style: pointChargeTitleStyle),
            Center(
              child: Container(
                child: Card(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      child:Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('40000point/월'),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                      '40000원',
                                      style: TextStyle(fontSize: 12, color:Colors.grey, decoration: TextDecoration.lineThrough)
                                  ),
                                  RaisedButton(
                                    child: Text('32000원', style: TextStyle(color: Colors.white)),
                                    color: Color.fromRGBO(0, 100, 0, 1),
                                    //onPressed: () async=>goBootpayRequest(context),
                                    onPressed: () => Navigator.push(context, MaterialPageRoute(
                                      builder:(context)=>Payment(),
                                    )),
                                  )
                                ],
                              )
                            ],
                          ),
//                          RaisedButton(
//                            child: Row(
//                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                              children: <Widget>[
//                                Text('40000point/월'),
//                                Row(
//                                  crossAxisAlignment: CrossAxisAlignment.end,
//                                  children: <Widget>[
//                                    Text(
//                                        '40000원',
//                                        style: TextStyle(fontSize: 12, color:Colors.grey, decoration: TextDecoration.lineThrough)
//                                    ),
//                                    Text('32000원', style: TextStyle(color: Colors.black)),
//                                  ],
//                                )
//                              ],
//                            ),
//                            onPressed: (){},
//                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('60000point/월'),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                      '60000원',
                                      style: TextStyle(fontSize: 12, color:Colors.grey, decoration: TextDecoration.lineThrough)
                                  ),
                                  RaisedButton(
                                    child: Text('48000원', style: TextStyle(color: Colors.white)),
                                    color: Colors.green,
                                    onPressed: (){},
                                  )
                                ],
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('80000point/월'),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    '80000원',
                                    style: TextStyle(fontSize: 12, color:Colors.grey, decoration: TextDecoration.lineThrough)
                                  ),
                                  RaisedButton(
                                    child: Text('64000원', style: TextStyle(color: Colors.white)),
                                    color: COLOR_SSDAM,
                                    splashColor: Color.fromRGBO(0, 100, 0, 1),
                                    animationDuration : Duration(seconds: 5),
                                    onPressed: (){},
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      )
                    )
                )
              )
            ),
            SizedBox(height: 30,),
            Text('포인트 충전', style: pointChargeTitleStyle),
            Center(
                child: Container(
                    child: Card(
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                            child:Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('10000point'),
                                    RaisedButton(
                                      child: Text('10000원', style: TextStyle(color: Colors.white)),
                                      color: COLOR_SSDAM,
                                      onPressed: (){},
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('20000point'),
                                    RaisedButton(
                                      child: Text('20000원', style: TextStyle(color: Colors.white)),
                                      color: COLOR_SSDAM,
                                      onPressed: (){},
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('40000point'),
                                    RaisedButton(
                                      child: Text('40000원', style: TextStyle(color: Colors.white)),
                                      color: COLOR_SSDAM,
                                      onPressed: (){},
                                    )
                                  ],
                                ),
                              ],
                            )
                        )
                    )
                )
            ),
          ],
        )
    );
  }
}