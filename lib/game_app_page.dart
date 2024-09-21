import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GameAppPage extends StatefulWidget {
  const GameAppPage({super.key});

  @override
  State<GameAppPage> createState() => _GameAppPageState();
}

class _GameAppPageState extends State<GameAppPage> {
  double _progress = 0;
  late InAppWebViewController inAppWebViewController;

  @override
  void initState() {
    super.initState();
    // Hide system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    // Restore system UI when leaving this screen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.black,
      //   centerTitle: true,
      //   title: Text(
      //     'GullyBet App',
      //     style: TextStyle(
      //       color: Colors.grey[400],
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      //   actions: [
      //     IconButton(
      //       onPressed: () {
      //         _launchURL('https://t.me/LottoProAi_bot');
      //       },
      //       icon: Icon(
      //         Icons.telegram,
      //         size: 35.0,
      //         color: Colors.grey[400],
      //       ),
      //     ),
      //   ],
      // ),
      body: SafeArea(
        child: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri(''),
              ),
              onWebViewCreated: (InAppWebViewController controller) {
                inAppWebViewController = controller;
              },
              onProgressChanged:
                  (InAppWebViewController controller, int progress) {
                setState(() {
                  _progress = progress / 100;
                });
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                var uri = navigationAction.request.url!;
                if (![
                  "http",
                  "https",
                  "file",
                  "chrome",
                  "data",
                  "javascript",
                  "about"
                ].contains(uri.scheme)) {
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                    return NavigationActionPolicy.CANCEL;
                  }
                }
                return NavigationActionPolicy.ALLOW;
              },
            ),
            _progress < 1 ? const LoadingScreen() : const SizedBox(),
          ],
        ),
      ),
      floatingActionButton: DraggableFab(
        child: FloatingActionButton(
            backgroundColor: const Color(0xffd8cccc),
            onPressed: () {
              _launchURL(''); // LottoProAi_bot | LotteryGPTBot
            },
            child: const Icon(
              Icons.article_outlined,
              size: 30.0,
              color: Color(0xff312525),
            )
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(8.0),
            //   child: Image.asset(
            //     'assets/images/teleIcon.png',
            //     fit: BoxFit.cover,
            //   ),
            // ),
            ),
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xffd8cccc),
        // decoration: const BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage(
        //       'assets/images/homeBG.png',
        //     ),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 130.0,
              ),
              const SizedBox(height: 25.0),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: LinearProgressIndicator(
                  color: Colors.grey,
                ),
              ),
              // const Text(
              //   'Loading...',
              //   style: TextStyle(
              //     fontSize: 20.0,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.white,
              //   ),
              // ),
            ],
          ),
        ));
  }
}
