import 'dart:io';
import 'dart:isolate';
import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:enigma/enigma.dart';

class EnigmaSolver{

  EnigmaSolver();

  Solution? output;

  late SendPort mainSend;

  ReceivePort rcv = ReceivePort();

  ReceivePort rco = ReceivePort();

  int workers = Platform.numberOfProcessors;

  String crypt = "";

  var propabilitygrid = [
    0.0648988136775994,
    0.0188415910676902,
    0.0305054331572126,
    0.0506430066792942,
    0.173462266972386,
    0.0165486990329977,
    0.0300069783670621,
    0.0474528960223308,
    0.0752666733127305,
    0.00269165586681288,
    0.0120626059216429,
    0.0342936895623567,
    0.025221812381617,
    0.0974977569534443,
    0.0250224304655568,
    0.00787558568437843,
    0.000199381916060213,
    0.0697836706210747,
    0.0724753264878875,
    0.0613099391885156,
    0.0433655667430964,
    0.00667929418801715,
    0.0188415910676902,
    0.00029907287409032,
    0.000398763832120427,
    0.0112650782574021,];

  Stream bruteforce(String incrypt, {int? overrideworkers, Function? callback}) {
    rcv=ReceivePort();
    rco=ReceivePort();
    crypt = incrypt;
    overrideworkers!=null ? workers = overrideworkers : workers=Platform.numberOfProcessors;
    spawnIsol();
    //Isolate isolate = await Isolate.spawn(mainIsolate, rcv.sendPort);
    return rco;
  }

  void spawnIsol() async {
    await Isolate.spawn(mainIsolate, rcv.sendPort);
    mainSend = await rcv.first;
    mainSend.send(crypt);
    mainSend.send(propabilitygrid);
    mainSend.send(workers);
    mainSend.send(rco.sendPort);
  }

  void kill(){
    mainSend.send(null);
  }


}



Future<void> mainIsolate(SendPort snd) async {

  List<Isolate> isolates = [];
  ReceivePort receiver = ReceivePort();
  var rcstr = StreamQueue(receiver);
  //sleep(Duration(seconds: 1));
  snd.send(receiver.sendPort);

  String crypt = await rcstr.next;
  List<double> propabilitygrid = await rcstr.next;
  int running = await rcstr.next;
  SendPort output = await rcstr.next;

  rcstr.rest.listen((event) {
    if(event==null){
      for(var isolate in isolates){
        isolate.kill();
      }
      Isolate.exit();
    }
  });

  List<ReceivePort> rports = List<ReceivePort>.generate(running, (index) => ReceivePort());
  List<StreamQueue> rstr = rports.map((e) => StreamQueue(e)).toList();
  List<SendPort> sports = [];


  for(var i = 0;i<running;i++){
    isolates.add(await Isolate.spawn(workerTask, rports[i].sendPort));
    SendPort sp = await rstr[i].next;
    sports.add(sp);
    sp.send((i*400/running).ceil());
    sp.send(crypt.substring((400/running*i).ceil(),(400/running*(i+1)).ceil()));
    sp.send(propabilitygrid);
  }
  var stopwatch = Stopwatch();
  stopwatch.start();


  output.send(Update(stopwatch.elapsed));

  var rstrc = StreamQueue(StreamGroup.merge(rstr.map((e) => e.rest)));
  final Uint8List allposccomplete = await rstrc.next as Uint8List;
  Uint8List get;
  for(var aaa = 1;aaa<running;aaa++){
    get = await rstrc.next as Uint8List;
    for(var aab = 0; aab< get.length;aab++){
      allposccomplete[aab]+=get[aab];
    }
  }
  List<List<int>> solutions = List<List<int>>.generate(allposccomplete.length, (index) => [index, allposccomplete[index]]);
  /*

  while(solutions.length<poss){
    var get = await rstrc.next as Solution;
      solutions.add(get);
      if(counter<poss) {
        sports[get.workerID].send(counter);
        counter++;
        //print((counter / poss).toString() + '\r');
        if(counter%1000==0) {
          output.send(Update(counter / poss, stopwatch.elapsed, counter));
        }
      }else{
        sports[get.workerID].send(null);
      }
  }

   */

  output.send(Update(stopwatch.elapsed,finishing: true));

  /*
  while(solutions.length<poss){
    for(var i = 0;i<running;i++){
      if(await rstr[i].hasNext){
        var get = await rstr[i].next;
        if(get is Solution){
          solutions.add(get);
          if(counter<poss){
            sports[i].send(counter);
            counter++;
            print((counter/poss).toString()+'\r');
            //output.send(Update(counter/poss, stopwatch.elapsed));
          }else{
            sports[i].send(null);
          }
        }
      }
    }
  }
  */

  for(var port in rports){
    port.close();
  }
  solutions.sort((a,b) => b[1].compareTo(a[1]));

  var tmp = solutions.take(10).toList().map((e) {
    int ukw = (e[0]%3)+100;
    int w3 = ((e[0]/78).floor()%3)+1;
    int s3 = (e[0]/3).floor()%26;
    int w2 = ((e[0]/6084).floor()%3)+1;
    int s2 = (e[0]/234).floor()%26;
    int w1 = ((e[0]/474551).floor()%3)+1;
    int s1 = (e[0]/18252).floor()%26;
    var enigma = Enigma(w1, s1, w2, s2, w3, s3, ukw);
    var clear = enigma.schluesselnString(crypt);
    return Solution(e[0], clear, e[1].toDouble(), 0);
  }).toList();
  stopwatch.stop();
  output.send(Finish(tmp, stopwatch.elapsed));
  //print(solutions.first.clear);
  //print(solutions.first.score);
  Isolate.exit();
}

void workerTask(SendPort snd) async {
  var rcv = ReceivePort();
  var rcvs = StreamQueue(rcv);
  String crypt;
  List<double> propabilitygrid;
  snd.send(rcv.sendPort);
  int predchars = await rcvs.next;
  crypt = await rcvs.next;
  propabilitygrid = await rcvs.next;
  final Uint8List allposc = Uint8List(1423656);
  ByteData curpos;
  List<int> cryptnum = List<int>.generate(crypt.length,(index) =>crypt.codeUnits[index]-65);
  for(var aaa = 0;aaa<cryptnum.length;aaa++){
    curpos = ByteData.view(File("lib/assets/allpossibilitiesbyletter/" + (predchars+aaa).toString() + "/" + cryptnum[aaa].toString() + ".bin").readAsBytesSync().buffer);
    //curposb = ByteData.view(curpos);
    for (int aab = 0; aab < curpos.lengthInBytes/4; aab++)
    {
      allposc[curpos.getUint32(aab*4)]++;
      //print(curpos.getUint32(aab*4));
    }
  }
  snd.send(allposc);
  /*
  allposc.sort;
  print(allposc[0]);

   */
  /*
  while(true){
    var get = await rcvs.next;

    if (get is int){
      int ukw = (get%3)+100;
      int w3 = ((get/3).round()%3)+1;
      int s3 = (get/3/3).round()%26;
      int w2 = ((get/3/3/26).round()%3)+1;
      int s2 = (get/3/3/26/3).round()%26;
      int w1 = ((get/3/3/26/3/26).round()%3)+1;
      int s1 = (get/3/3/26/3/26/3).round()%26;
      var enigma = Enigma(w1, s1, w2, s2, w3, s3, ukw);
      var clear = enigma.schluesselnString(crypt);
      double score = 0;
      for(int i = 0;i<26;i++){
        var count = intToChar(i).allMatches(clear).length;
        score+=logdb(clear.length, propabilitygrid[i], count);
      }


      snd.send(Solution(get, clear, score, workerID));
    }else{
      break;
    }
  }

     */
  Isolate.exit();
}

double logdb(num n,num p,num x){
  if(x==0){
    return n*log(1-p);
  }
  return log(sqrt(n))+n*log(n)-log(sqrt(2*pi*x*(n-x)))-x*log(x)-(n-x)*log(n-x)+x*log(p)+(n-x)*log(1-p);
}

class Update{
  Duration time;
  bool finishing;
  Update(this.time,{this.finishing = false});
}

class Finish{
  List<Solution> solutions;
  Duration time;
  Finish(this.solutions,this.time);
}

abstract class WorkerAnswer{
  int workerID;
  WorkerAnswer(this.workerID);
}

class Solution extends WorkerAnswer{
  int config;
  String clear;
  double score;
  Solution(this.config,this.clear,this.score,int workerID) : super(workerID);
}