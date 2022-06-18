//0..25 A..Z

List<String> alphabet = List<String>.generate(26, (int index) {
  return String.fromCharCode(index + 65);
});

List<int> charToInt(String chars) {
  List<int> tmp = [];
  List<String> char = chars.split('');
  for (int i = 0; i < chars.length; i++) {
    var t = alphabet.indexOf(char[i].toUpperCase());
    if(t!=-1) tmp.add(t);
  }
  return tmp;
}

String intToChar(int input) {
  return alphabet[input];
}

String intsToChars(List<int> input){
  String tmp = "";
  input.forEach((element) {
    tmp+=alphabet[element%26];
  });
  return tmp;
}

class Enigma {
  late List<Walze> walzen;
  late Walze umkehrwalze;

  String schluesselnString(String input){
    var tmp = charToInt(input);
    List<int> tmp2=[];
    tmp.forEach((element) {
      tmp2.add(schluesselnChar(element));
    });
    return intsToChars(tmp2);
  }

  int schluesselnChar(int char) {
    if(walzen[0].position+1==walzen[0]._uebertragskerbe) {
      walzen[1].position=(walzen[1].position+1)%26;
    } else if(walzen[1].position+1==walzen[1]._uebertragskerbe){
      walzen[1].position=(walzen[1].position+1)%26;
    }
    if(walzen[1].position+1==walzen[1]._uebertragskerbe){
      walzen[2].position=(walzen[2].position+1)%26;
    }
    walzen[0].position=(walzen[0].position+1)%26;
    return walzen[0].revVerschluesseln(walzen[1].revVerschluesseln(walzen[2].revVerschluesseln(
        umkehrwalze.verschluesseln(walzen[2].verschluesseln(
            walzen[1].verschluesseln(walzen[0].verschluesseln(char)))))));
  }

  Enigma(int w1, int s1, int w2, int s2, int w3, int s3, int u) {
    walzen = [Walze(s1, w1), Walze(s2, w2), Walze(s3, w3)];
    umkehrwalze = Walze(0, u);
  }
}

class Walze {
  int position = 0;
  List<int> _verkabelung=[];
  int _uebertragskerbe = 100;

  int verschluesseln(int char) {
    return (_verkabelung[(char + position)%26]-1-position)%26;
  }

  int revVerschluesseln(int char){
    return (_verkabelung.indexOf((char + position)%26+1)-position)%26;
  }

  Walze(int startposition, int nummer) {
    position = startposition;
    switch (nummer) {
      case 1:
        _verkabelung = [
          5,
          11,
          13,
          6,
          12,
          7,
          4,
          17,
          22,
          26,
          14,
          20,
          15,
          23,
          25,
          8,
          24,
          21,
          19,
          16,
          1,
          9,
          2,
          18,
          3,
          10
        ];
        _uebertragskerbe = 17;
        break;
      case 2:
        _verkabelung = [
          1,
          10,
          4,
          11,
          19,
          9,
          18,
          21,
          24,
          2,
          12,
          8,
          23,
          20,
          13,
          3,
          17,
          7,
          26,
          14,
          16,
          25,
          6,
          22,
          15,
          5
        ];
        _uebertragskerbe = 5;
        break;
      case 3:
        _verkabelung = [
          2,
          4,
          6,
          8,
          10,
          12,
          3,
          16,
          18,
          20,
          24,
          22,
          26,
          14,
          25,
          5,
          9,
          23,
          7,
          1,
          11,
          13,
          21,
          19,
          17,
          15
        ];
        _uebertragskerbe = 22;
        break;
      case 100:
        _verkabelung = [
          5,
          10,
          13,
          26,
          1,
          12,
          25,
          24,
          22,
          2,
          23,
          6,
          3,
          18,
          17,
          21,
          15,
          14,
          20,
          19,
          16,
          9,
          11,
          8,
          7,
          4
        ];
        _uebertragskerbe = 100;
        break;
      case 101:
        _verkabelung = [
          25,
          18,
          21,
          8,
          17,
          19,
          12,
          4,
          16,
          24,
          14,
          7,
          15,
          11,
          13,
          9,
          5,
          2,
          6,
          26,
          3,
          23,
          22,
          10,
          1,
          20
        ];
        _uebertragskerbe = 100;
        break;
      case 102:
        _verkabelung = [
          6,
          22,
          16,
          10,
          9,
          1,
          15,
          25,
          5,
          4,
          18,
          26,
          24,
          23,
          7,
          3,
          20,
          11,
          21,
          17,
          19,
          2,
          14,
          13,
          8,
          12
        ];
        _uebertragskerbe = 100;
        break;
    }
  }
}
