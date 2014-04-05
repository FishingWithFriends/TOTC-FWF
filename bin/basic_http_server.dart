import 'dart:io';
import 'package:http_server/http_server.dart';

main() {

  handleService(HttpRequest request) {
    print('New service request');
    request.response.write('[{"field":"value"}]');
    request.response.close();
  };

  HttpServer.bind('127.0.0.1', 8888).then((HttpServer server) {
    VirtualDirectory vd = new VirtualDirectory('../build/');
    vd.jailRoot = false;
    server.listen((request) { 
      print("request.uri.path: " + request.uri.path);
      if (request.uri.path == '/services') {
        handleService(request);
      } else {
        print('File request');
        vd.serveRequest(request);
      } 
    });
  });
}