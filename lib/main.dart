import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;

void main() {
  runApp(const MyApp());
}

const String viewType = 'zelleviewtype';

Widget _buildAndroid(BuildContext context, Map<String, dynamic> params) {
  return AndroidView(
    viewType: viewType,
    layoutDirection: TextDirection.ltr,
    creationParams: params,
    creationParamsCodec: const StandardMessageCodec(),
  );
}

Widget _buildIoS(BuildContext context, Map<String, dynamic> params) {
  return UiKitView(
    viewType: viewType,
    layoutDirection: TextDirection.ltr,
    creationParams: params,
    creationParamsCodec: const StandardMessageCodec(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool launchZelleUI = false;

  TextEditingController _applicationNameController = TextEditingController();
  TextEditingController _baseUrlController = TextEditingController();
  TextEditingController _institutionIdController = TextEditingController();
  TextEditingController _productController = TextEditingController();
  TextEditingController _ssoKeyController = TextEditingController();

  FocusNode _applicationNameFocus = FocusNode();
  FocusNode _baseUrlFocus = FocusNode();
  FocusNode _institutionIdFocus = FocusNode();
  FocusNode _productFocus = FocusNode();
  FocusNode _ssoKeyFocus = FocusNode();

  void _lauchZelle() async{
    setState(() {
      launchZelleUI = true ;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> map = new HashMap();
    map['param1'] = "1234";
    map['param2'] = "something";
    map['param3'] = "abc123";

    Map<String,Map<String, String>> pdData=new LinkedHashMap();
    //contact
    Map<String, String> contact_pd = new LinkedHashMap();
    contact_pd['title'] = "CONTACT TITLE";
    contact_pd['message'] = "CONTACT MESSAGE";
    //camera
    Map<String, String> camera_pd = new LinkedHashMap();
    camera_pd['title'] = "CAMERA TITLE";
    camera_pd['message'] = "CAMERA MESSAGE";
    //gallery
    Map<String, String> gallery_pd = new LinkedHashMap();
    gallery_pd['title'] = "GALLERY TITLE";
    gallery_pd['message'] = "GALLERY MESSAGE";

    pdData['pd_contact'] = contact_pd;
    pdData['pd_camera'] = camera_pd;
    pdData['pd_gallery'] = gallery_pd;

    // https://dhayalu-fiserv.github.io/demo/index.html
    // https://jayjt11.github.io/Sdk/index.html

    final Map<String, dynamic> params = <String, dynamic>{};
    params['applicationName'] = _applicationNameController.text;
    params['baseUrl'] =  _baseUrlController.text;
   // params['baseUrl'] = Platform.isAndroid ?'https://dhayalu-fiserv.github.io/demo/index.html' : 'https://jayjt11.github.io/Sdk/index.html';
    params['institutionId'] = _institutionIdController.text;
    params['product'] = _productController.text;
    params['ssoKey'] = _ssoKeyController.text;
    params['fi_callback'] = true;
    params['appData'] = pdData;
    params['parameter'] = map;

    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Center(child: Text('Embedded Native View')),
            ),

            SliverToBoxAdapter(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10,),
                  Text("Welcome to Zelle"),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _applicationNameController,
                      focusNode: _applicationNameFocus,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(_baseUrlFocus);
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter application name',
                      ),
                    ),

                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _baseUrlController,
                      focusNode: _baseUrlFocus,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(_institutionIdFocus);
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter baseUrl',
                      ),
                    ),

                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _institutionIdController,
                      focusNode: _institutionIdFocus,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(_productFocus);
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter institutionId',
                      ),
                    ),

                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _productController,
                      focusNode: _productFocus,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(_ssoKeyFocus);
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter product',
                      ),
                    ),

                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _ssoKeyController,
                      focusNode: _ssoKeyFocus,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter ssoKey',
                      ),
                    ),

                  ),
                  ElevatedButton(onPressed: _lauchZelle, child:
                  Text(
                      "Launch Zelle"
                  )),
                  SizedBox(height: 10,),
                  launchZelleUI ?
                  SizedBox(height: MediaQuery.of(context).size.height*1.05, child: Platform.isAndroid ? _buildAndroid(context, params) : _buildIoS(context, params)): SizedBox()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
