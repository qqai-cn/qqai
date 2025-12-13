// import 'dart:convert';
// import 'dart:io';
//
// import 'package:file_selector/file_selector.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:flutter_chat_types/flutter_chat_types.dart';
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';
// import 'package:http/http.dart' as http;
// import 'package:mime/mime.dart';
// import 'package:open_filex/open_filex.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:uuid/uuid.dart';
//
// import '../../../constant/constant.dart';
//
// class ChatPage extends StatefulWidget {
//   final int chatId;
//
//   ChatPage({this.chatId = 0});
//
//   final String apiKey = 'AIzaSyAt0ShYb9fCcUs3urCNiVn5KU0DVLKg0WQ';
//
//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }
//
// class _ChatPageState extends State<ChatPage> {
//   late final GenerativeModel _model;
//   late final GenerativeModel _visionModel;
//   late final ChatSession _chat;
//   bool _loading = false;
//
//   List<types.Message> _messages = [];
//   final _user = const types.User(
//     id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
//   );
//
//   final _aiUser = const types.User(id: '1', firstName: 'A', lastName: 'I');
//
//   @override
//   void initState() {
//     super.initState();
//     _loadMessages();
//     _loadAi();
//   }
//
//   _loadAi() {
//     _model = GenerativeModel(
//       model: 'gemini-pro',
//       apiKey: widget.apiKey,
//     );
//     _visionModel = GenerativeModel(
//       model: 'gemini-pro-vision',
//       apiKey: widget.apiKey,
//     );
//     _chat = _model.startChat();
//   }
//
//   void _addMessage(types.Message message) {
//     setState(() {
//       _messages.insert(0, message);
//     });
//   }
//
//   void _handleAttachmentPressed() {
//     showModalBottomSheet<void>(
//       constraints: BoxConstraints(maxHeight: 200),
//       context: context,
//       isScrollControlled: true,
//       builder: (BuildContext context) => SafeArea(
//         child: SizedBox(
//           height: 144,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   _handleImageSelection();
//                 },
//                 child: const Align(
//                   alignment: AlignmentDirectional.centerStart,
//                   child: Text('图片'),
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   _handleFileSelection();
//                 },
//                 child: const Align(
//                   alignment: AlignmentDirectional.centerStart,
//                   child: Text('文件'),
//                 ),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Align(
//                   alignment: AlignmentDirectional.centerStart,
//                   child: Text('取消'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _handleFileSelection() async {
//     final XFile? file = await openFile(acceptedTypeGroups: <XTypeGroup>[]);
//
//     if (file != null) {
//       final bytes = await file.readAsBytes();
//       final message = types.FileMessage(
//         author: _user,
//         createdAt: DateTime.now().millisecondsSinceEpoch,
//         id: const Uuid().v4(),
//         mimeType: lookupMimeType(file.path),
//         name: file.name,
//         size: bytes.length,
//         uri: file.path,
//       );
//
//       _addMessage(message);
//     }
//   }
//
//   void _handleImageSelection() async {
//     // #docregion MultiOpen
//     const XTypeGroup jpgsTypeGroup = XTypeGroup(
//       label: 'JPEGs',
//       extensions: <String>['jpg', 'jpeg'],
//     );
//     const XTypeGroup pngTypeGroup = XTypeGroup(
//       label: 'PNGs',
//       extensions: <String>['png'],
//     );
//     final XFile? file = await openFile(acceptedTypeGroups: <XTypeGroup>[
//       jpgsTypeGroup,
//       pngTypeGroup,
//     ]);
//
//     if (file != null) {
//       final bytes = await file.readAsBytes();
//       final image = await decodeImageFromList(bytes);
//
//       final message = types.ImageMessage(
//         author: _user,
//         createdAt: DateTime.now().millisecondsSinceEpoch,
//         height: image.height.toDouble(),
//         id: const Uuid().v4(),
//         name: file.name,
//         size: bytes.length,
//         uri: file.path,
//         width: image.width.toDouble(),
//       );
//
//       _addMessage(message);
//     }
//   }
//
//   void _handleMessageTap(BuildContext _, types.Message message) async {
//     if (message is types.FileMessage) {
//       var localPath = message.uri;
//
//       if (message.uri.startsWith('http')) {
//         try {
//           final index =
//               _messages.indexWhere((element) => element.id == message.id);
//           final updatedMessage =
//               (_messages[index] as types.FileMessage).copyWith(
//             isLoading: true,
//           );
//
//           setState(() {
//             _messages[index] = updatedMessage;
//           });
//
//           final client = http.Client();
//           final request = await client.get(Uri.parse(message.uri));
//           final bytes = request.bodyBytes;
//           final documentsDir = (await getApplicationDocumentsDirectory()).path;
//           localPath = '$documentsDir/${message.name}';
//
//           if (!File(localPath).existsSync()) {
//             final file = File(localPath);
//             await file.writeAsBytes(bytes);
//           }
//         } finally {
//           final index =
//               _messages.indexWhere((element) => element.id == message.id);
//           final updatedMessage =
//               (_messages[index] as types.FileMessage).copyWith(
//             isLoading: null,
//           );
//
//           setState(() {
//             _messages[index] = updatedMessage;
//           });
//         }
//       }
//
//       await OpenFilex.open(localPath);
//     }
//   }
//
//   void _handlePreviewDataFetched(
//     types.TextMessage message,
//     types.PreviewData previewData,
//   ) {
//     final index = _messages.indexWhere((element) => element.id == message.id);
//     final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
//       previewData: previewData,
//     );
//
//     setState(() {
//       _messages[index] = updatedMessage;
//     });
//   }
//
//   Future<void> _handleSendPressed(types.PartialText message) async {
//     final textMessage = types.TextMessage(
//       author: _user,
//       createdAt: DateTime.now().millisecondsSinceEpoch,
//       id: const Uuid().v4(),
//       text: message.text,
//     );
//
//     _addMessage(textMessage);
//
//     _loading = true;
//     final response = await _chat
//         .sendMessage(
//       Content.text(message.text),
//     )
//         .then((response) {
//       _loading = false;
//       final responseMessage = types.TextMessage(
//           author: _aiUser,
//           createdAt: DateTime.now().millisecondsSinceEpoch,
//           id: const Uuid().v4(),
//           text: MarkdownBody(data: response.text!).data,
//           type: MessageType.text);
//       _addMessage(responseMessage);
//     });
//   }
//
//   void _loadMessages() async {
//     final response = await rootBundle.loadString('mock/ai_message.json');
//     final messages = (jsonDecode(response) as List)
//         .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
//         .toList();
//     setState(() {
//       _messages = messages;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         leading: 1.sw < Constant.CHAT_TWO_VIEW_WIDTH
//             ? BackButton(
//                 color: Colors.blue,
//               )
//             : null,
//         title: Text(
//           widget.chatId.toString(),
//           style: TextStyle(color: Colors.black),
//         ),
//         actions: [
//           IconButton(
//               onPressed: null,
//               icon: Icon(
//                 Icons.more_horiz,
//               ))
//         ],
//       ),
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: Chat(
//               messages: _messages,
//               onAttachmentPressed: _handleAttachmentPressed,
//               onMessageTap: _handleMessageTap,
//               onPreviewDataFetched: _handlePreviewDataFetched,
//               onSendPressed: _handleSendPressed,
//               showUserAvatars: true,
//               showUserNames: true,
//               user: _user,
//               theme: const DefaultChatTheme(
//                 inputBackgroundColor: Colors.black12,
//                 inputTextColor: Colors.black,
//                 seenIcon: CircleAvatar(
//                   radius: 18,
//                   backgroundColor: Colors.grey,
//                   backgroundImage: AssetImage('imgs/defbak.png'),
//                 ),
//               ), currentUserId: '', resolveUser: (String id) {  }, chatController: null,
//             ),
//           ),
//           if (_loading)
//             Positioned.fill(
//               child: Center(
//                 child: CircularProgressIndicator(
//                   color: Colors.blue,
//                   backgroundColor: Colors.white,
//                 ),
//               ),
//             ),
//         ],
//       ));
// }
