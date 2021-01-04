import 'dart:io';
import 'dart:core';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'user-agents.dart';

// Main
const version = '1.0.0';



// CLI colors
class C {
  final _ = '\u001b[0m';
  final p = '\u001b[38;5;204m';
  final o = '\u001b[38;5;208m';
  final b = '\u001b[38;5;295m';
  final c = '\u001b[38;5;299m';
  final g = '\u001b[38;5;47m';
  final r = '\u001b[38;5;1m';
  final y = '\u001b[38;5;226m';
}
final c = C();

// Handle error messages
void errorMessage(msg, {e=null}) {
  print('${c.r}[-]${c._} $msg');
  e != null ? print('    ${c.o}Stacktrace:${c._} $e') : null;
  exit(1);
}

// File name and directory path
final filename = Platform.script.toString().split('/').removeLast();
final working_dir = Platform.script.toString().replaceFirst('file://','').substring(0,Platform.script.toString().replaceFirst('file://','').length-filename.length);


const commands = [
  {
    'name':['scan'],
    'parameter':null,
    'description':'Primary command for scanning.',
    'usage':['scan -u https://example.com/'],
    'default':null
  },
  {
    'name':['useragents'],
    'parameter':null,
    'description':'Prints available useragents.',
    'usage':['useragents'],
    'default':null
  },
  {
    'name':['-h','--help','help'],
    'parameter':null,
    'description':'Prints this help screen.',
    'usage':['-h'],
    'default':null
  },
];
const flags = [
  {
    'name':['-u','--url'],
    'parameter':'<url/host>',
    'description':'Specify a url / host to start the crawler on.',
    'usage':['-u https://google.com'],
    'default':null
  },
  {
    'name':['-a','--all-domains'],
    'parameter':null,
    'description':'Will scan pages on all domains.',
    'usage':['-a'],
    'default':false
  },
  {
    'name':['-e','--exclusions'],
    'parameter':'<exclusions>',
    'description':'If a url contains any of the exclusions specified the url will be skipped, values are comma delimited',
    'usage':['-e .png,.jpeg,.jpg','-e ?C=D;O=A,?C=M;O=A,?C=N;O=D,?C=S;O=A'],
    'default':null
  },
  {
    'name':['-U','--useragent'],
    'parameter':'<id/custom>',
    'description':'Specify user agent, supports built in and custom user agents. For custom UAs escape space characters with "\".',
    'usage':['-U 1','-U Internet\\ Browser\\ Version\\ 10'],
    'default':'rotate'
  },
  {
    'name':['-v','--verbose'],
    'parameter':null,
    'description':'Makes output more verbose by printing errors and warnings.',
    'usage':['-v'],
    'default':false
  },
  {
    'name':['-d','--delay'],
    'parameter':'<integer>',
    'description':'Specify delay between requests in seconds. Make sure to take threading into consideration.',
    'usage':['-d 5'],
    'default':'0'
  },
  {
    'name':['-o','--output'],
    'parameter':'<filepath>',
    'description':'Specify an output file, if file does not exist one will be created.',
    'usage':['-o output.txt'],
    'default':null
  },
  {
    'name':['-c','--cookies'],
    'parameter':'<cookie(s)>',
    'description':'Specify raw cookie data.',
    'usage':['-c requestid=amVzdXMgbG92ZXMgeW91;','-c user=admin;pass=1234569;'],
    'default':null
  },
  {
    'name':['-t','--timeout'],
    'parameter':'<integer(s)>',
    'description':'Specify raw cookie data.',
    'usage':['-t 5'],
    'default':5
  },
];


dynamic parseFlags(List<String> args, Map flag, {bool has_value = true}) {
  for (var i = 0; i < args.length; i++) {
    for (var prefix in flag['name']) {
      if (prefix == args[i]) {
        if (has_value) {
          try {
            return args[i+1];
          } catch (e) {
            return null;
          }
        } else {
          return true;
        }
      } else {
      }
    }
  }
  return flag['default'];
}

void agents() {
  print('${c.y}ID | User Agent');
  for (var i = 0; i < user_agents.length; i++) {
    print('${c.g}${i.toString().padRight(2)}${c.y} |${c._} ${user_agents[i]}');
  }
}

void help() {
  print("""${c.o}
________              _____     _________                       ______            
___  __ \\_____ _________  /_    __  ____/____________ ___      ____  /____________
__  / / /  __ `/_  ___/  __/    _  /    __  ___/  __ `/_ | /| / /_  /_  _ \\_  ___/
_  /_/ // /_/ /_  /   / /_      / /___  _  /   / /_/ /__ |/ |/ /_  / /  __/  /    
/_____/ \\__,_/ /_/    \\__/      \\____/  /_/    \\__,_/ ____/|__/ /_/  \\___//_/     
              ${c.y}>>>>>>>_____________________\\`-._                       ${c.c}v:$version
              ${c.y}>>>>>>>                     /.-'""");
  print('${c.b}Author:${c.g} Gray   ${c.b}Website:${c.g} https://lambda.black/   ${c.b}Github:${c.g} https://github.com/GrayWasTaken');
  print('\n${c.o}Commands:');
  for (var x in commands) {
    var tmp = '${c.y}  ';
    for (var t in x['name']) {
      tmp+= '$t ${x['parameter'] != null ? x['parameter'].toString() + ' ' : ''}';
    }
    print(tmp);
    print('${c.b}    ${x['description']}');
    for (var t in x['usage']) {
      print('${c.c}    Usage: dartcrawler $t');
    }
    x['default'] != null ? print('${c.c}    Default: ${x['default']}') : null;
  }
  print('\n${c.o}Scan Flags:');
  for (var x in flags) {
    var tmp = '${c.y}  ';
    for (var t in x['name']) {
      tmp+= '$t ${x['parameter'] != null ? x['parameter'].toString() + ' ' : ''}';
    }
    print(tmp);
    print('${c.b}    ${x['description']}');
    for (var t in x['usage']) {
      print('${c.c}    Usage: dartcrawler $t');
    }
    x['default'] != null ? print('${c.c}    Default: ${x['default']}') : null;
  }
}





















// TODO FLAGS # of "threads", max filesize flag










Future<void> scanUrl() async {
  var url;
  var r;
  var error_occured = false;
  var hash;
  if (user_agent == 'rotate') {
    headers['User-Agent'] = user_agents[Random().nextInt(user_agents.length)];
  }

  void error(msg) async {
    if (verbosity) {
      print('${c.r}[-]${c._} Q: ${queue.length.toString().padLeft(4)}, P: ${processing.length.toString().padLeft(4)}, S: ${scanned.length.toString().padLeft(4)} ${c.p}$url${c._} $msg');
    }
    processing.remove(url);
  }



  try {
    url = queue[0];
  } catch (e) {
    return;
  }
  queue.remove(url);
  processing.add(url);
  // print('${c.o}[*]${c._} Trying $url');

  // delay
  if (delay > 0) {
    await Future.delayed(Duration(seconds: delay));
  }


  // If url content > 1MB
  try {
    r = await http.head(url, headers: headers).timeout(Duration(seconds: timeout));
  } catch (e) {
    error('${c.r}Error:${c._} $e');
    return;
  }
  var size = r.headers['content-length'] == null ? 0 : int.parse(r.headers['content-length']);
  if (size > 1000000) {
    error('exceeded 1mb, skipping. (size=${c.p}$size${c._})');
    error_occured = true;
  } else {
    try {
      r = await http.get(url, headers: headers).timeout(Duration(seconds: timeout));
    } catch (e) {
      error('${c.r}Error:${c._} $e');
      return;
    }
    hash = md5.convert(r.bodyBytes);
  }

  // If url has been scanned before and content hash already exists then skip
  for (var s in scanned) {
    if (hash == s && hash != null) {
      error('duplicate, skipping. (hash=${c.p}$hash${c._})');
      error_occured = true;
    }    
  }
  // if url contains any exclusions skip
  if (exclusions != null) {
    for (var e in exclusions) {
      if (url.contains(e)) {
        error('contains exclusion(s), skipping. (exclusion=${c.p}$e${c._})');
        error_occured = true;
      }
    }
  }

  // check if response is valid string and not an image or something.
  try {
    r.body.toString();
  } catch (e) {
    error(e);
    error_occured = true;
  }


  //// Analyze content ////
  /// make sure no error
  /// make sure if domain_only is on that the domain is in the url
  if (error_occured == false) {
    if (all_domains || url.contains(domain)) {
      // get all pure urls
      var re = RegExp(r'(http|ftp|https)://([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?');
        re.allMatches(r.body).forEach((match) {
          queue.add(match.group(0));
        });
      // get all href and src urls
      re = RegExp("(?:src|href)=[\'\"](.*?)[\'\"]");
      re.allMatches(r.body).forEach((match) {
        var u = match.group(1);
        if (u.length == 0) {
          // skip as invalid url
        } else if (u.substring(0,1) == '/') {
          queue.add('$protocol://$domain$u');
        } else if (u.length > 7) {
          if (u.substring(0,8) == 'https://' || u.substring(0,7) == 'http://') {
            // skip as previous regex already caught it
          }
        } else {
          queue.add('${url}$u');
        }
      });
      // remove duplicates
      queue = queue.toSet().toList();
    }
  }

  // Output results
  scanned.add(hash);

  await File('.scan-in-progress').writeAsString('$hash, ${r.statusCode}, ${r.contentLength}, ${r.headers['content-type']}, $url\n', mode: FileMode.append);

  // print stats
  if (error_occured == false) {
    print('${c.g}[+]${c._} Q: ${queue.length.toString().padLeft(4)}, P: ${processing.length.toString().padLeft(4)}, S: ${scanned.length.toString().padLeft(4)} ${c.b}$url${c._}');
  }
  processing.remove(url);
}







// Global declarations
// primary url
String url;
// domain of primary url
String domain;
// protocol of primary url
String protocol;
// base path of primary url
String base_path;
List<String> queue = [];
List<String> processing = [];
List scanned = [];

// CONFIG
bool all_domains = false;
List<String> exclusions;
bool verbosity = false;
dynamic user_agent;
dynamic delay;
dynamic output;
dynamic cookies;
dynamic timeout;
Map<String, String> headers;

void main(List<String> arguments) async {
  // Parse Arguments
  try {
    if (arguments[0].toLowerCase() == 'scan') {
      // pass
    } else if (arguments[0].toLowerCase() == 'help' || arguments[0].toLowerCase() == '--help' || arguments[0].toLowerCase() == '-h') {
      help();
      exit(0);
    } else if (arguments[0].toLowerCase() == 'useragents') {
      agents();
      exit(0);
    } else {
      errorMessage('Invalid command specified, ${c.p}${arguments[0]}${c._}, for help run ${c.p}dartcrawler help${c._}');
    }
  } catch (e) {
    help();
    exit(0);
  }

  // Parse Flags
  url = parseFlags(arguments, flags[0]);
  all_domains = parseFlags(arguments, flags[1]);
  exclusions = parseFlags(arguments, flags[2]) != null ? parseFlags(arguments, flags[2]).split(',') : null;
  user_agent = parseFlags(arguments, flags[3]);
  verbosity = parseFlags(arguments, flags[4], has_value: false);
  delay = parseFlags(arguments, flags[5]);
  output = parseFlags(arguments, flags[6]);
  cookies = parseFlags(arguments, flags[7]);
  timeout = parseFlags(arguments, flags[8]);


  // check flags
  // Check user_agent
  if (user_agent.toLowerCase() != 'rotate') {
    try {
      user_agent = user_agents[int.parse(user_agent)];
    } catch (e) {}
  }

  // Check delay
  try {
    delay = int.parse(delay);
  } catch (e) {
    errorMessage('Invalid delay specified ${c.p}$delay${c._}, delay must be a positive integer');
  }

  // Check timeout
  try {
    if (timeout.runtimeType != int) {
      timeout = int.parse(timeout);
    }
  } catch (e) {
    print(e);
    errorMessage('Invalid timeout specified ${c.p}$timeout${c._}, timeout must be a positive integer');
  }

  // Check output
  if (output != null) {
    try {
      await File(output).writeAsString('');
    } catch (e) {
      errorMessage('Invalid file path specified ${c.p}$output${c._}\n    Full Trace: ${c.o}$e');
    }
  }

  // Check cookies
  if (cookies != null) {
    headers = {'User-Agent':user_agent,'Cookie': cookies};
  } else {
    headers = {'User-Agent':user_agent};
  }
  
  // Clear contents of .scan-in-progress
  await File('.scan-in-progress').writeAsString('');
  
  // Validate input
  var match;
  try {
    match = RegExp(r'^(https?):\/\/([\.\-\w]*)(.*)?$').firstMatch(url).groups([1,2,3]);
  } catch (e) {
    errorMessage('Invalid url schema specified within ${c.p}${arguments[0]}${c._}, ensure that your url starts with either http or https.');
  }
  protocol = match[0];
  domain = match[1];
  base_path = match[2] ?? '/';

  // Add to queue
  queue.add('$protocol://$domain$base_path');
  processing.add('$protocol://$domain$base_path');

  // Scan specific variables
  var start_time = DateTime.now();
  var webserver;
  try {
    var r = await http.get(url, headers: headers);
    webserver = r.headers['server'];
  } catch (e) {
    errorMessage('Invalid url or host specified, ${c.p}$url${c._} is not up.',e: e);
  }

  // Pre scan message
  print(c.g+'='*75);
  print('${c.b}Start Time.....: ${c.c}${start_time.hour}:${start_time.minute}:${start_time.second}');
  print('${c.b}URL To Scan....: ${c.c}$url/');
  print('${c.b}Webserver......: ${c.c}$webserver');
  print('${c.b}Domains........: ${c.c}${all_domains ? 'any' : domain}');
  print('${c.b}Exclusions.....: ${c.c}${exclusions != null ? (exclusions.length <= 8 ? exclusions : exclusions.length) : null}');
  print('${c.b}User Agent.....: ${c.c}$user_agent ${user_agent == 'rotate' ? (user_agents.length) : ''}');
  print('${c.b}Cookies........: ${c.c}$cookies');
  // print('${c.b}Threads........: ${c.c}$threads');
  print('${c.b}Timeout........: ${c.c}${timeout}s');
  print('${c.b}Delay..........: ${c.c}${delay}s');
  print(c.g+'='*75);

  // Start scan
  while (queue.isNotEmpty && processing.isNotEmpty) {
    await Future.wait([
      for (var i = 0; i < queue.length; i++)
        scanUrl()
    ]);
  }
  print(c.g+'='*75);
  print('${c.b}Duration.......: ${c.c}${DateTime.now().difference(start_time).inSeconds}s (started: ${start_time})');
  print('${c.b}Unique Pages...: ${c.c}${scanned.length}');
  // print('${c.b}Total Errors...: ${c.c}$errors');
  // print('${c.b}Total Found....: ${c.c}${count-errors}');
  print('${c.b}Webserver......: ${c.c}$webserver');
  print('${c.b}User Agent.....: ${c.c}$user_agent ${user_agent == 'rotate' ? (user_agents.length) : ''}');
  print('${c.b}Cookies........: ${c.c}$cookies');
  print(c.g+'='*75);
  
  print('${c.o}[*]${c._} Hash                              Status Code  Content Length  Content Type  URL');

  // read scan file line by line
  await File('.scan-in-progress')
    .openRead()
    .transform(utf8.decoder)
    .transform(LineSplitter())
    .forEach((l) {
      final i = l.split(', ');
      if (i.length < 5) {
        print('${c.r}[-]${c._} Please report this, (l=$l)');
        return;
      }
      print('${c.g}[+]${c._} ${i[0] ?? '              NULL              '}  ${i[1].toString().padRight(11)}  ${i[2].toString().padRight(14)}  ${i[3].toString().padRight(12)}  ${i[4]}');
    });
  
  if (output !=null) {
    await File('.scan-in-progress').rename(output);
  } else {
    await File('.scan-in-progress').delete();
  }
  exit(0);
}