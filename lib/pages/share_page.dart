import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectpan/backend/constants.dart';
import 'package:projectpan/backend/post_handler.dart';
import 'package:projectpan/widgets/components.dart';
import 'package:projectpan/widgets/textfield.dart';
import 'package:provider/provider.dart';

class SharePage extends StatefulWidget {
  static const routeName = '/share';
  const SharePage({Key? key}) : super(key: key);

  @override
  State<SharePage> createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  late TextEditingController _captionCont;
  bool isLoading = false;
  Uint8List? postImg;

  _addImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('ADD IMAGE'),
            children: [
              const Divider(),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('using camera'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List _file = await PostHandler().imgPicker(ImageSource.camera);
                  setState(() {
                    postImg = _file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('from gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List _file = await PostHandler().imgPicker(ImageSource.gallery);
                  setState(() {
                    postImg = _file;
                  });
                },
              ),
            ],
          );
        });
  }

  void clearImg() {
    setState(() {
      postImg = null;
    });
  }

  void post(String uid, String userName, Uint8List img, String userPicUrl) async {
    setState(() {
      isLoading = true;
    });
    try {
      String res = await PostHandler().uploadPost(_captionCont.text, img, uid, userName, userPicUrl);
      if (res == 'post successful') {
        bildirim('Posted.', context);
        Navigator.pop(context);
      } else {
        bildirim(res, context);
      }
    } catch (e) {
      bildirim(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    _captionCont = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _captionCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final _acHandler = Provider.of<AccountInfoHandler>(context, listen: false);
    final _user = _acHandler.profile;
    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
        backgroundColor: balihai,
        appBar: AppBar(
          backgroundColor: balihai,
          automaticallyImplyLeading: false,
          leading: BackButton(color: ebonyclay, onPressed: (() => {Navigator.pop(context)})),
          elevation: 0,
          actions: [
            TextButton(
              onPressed: () {
                if (postImg != null) {
                  post(_user.userId, _user.userName, postImg!, _user.userPicUrl);
                } else {
                  bildirim('select an image', context);
                }
              },
              child: const Icon(Icons.check, color: ebonyclay, size: 27),
            ),
            const SizedBox(width: 5),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              Stack(
                alignment: Alignment.center,
                children: [
                  PostPreview(
                    postArtUrl: postImg,
                    postDesc: _captionCont.text.isNotEmpty ? _captionCont.text : '. . .',
                    size: size,
                    songName: 'select a song',
                    userName: _user.userName,
                    userPicUrl: _user.userPicUrl,
                  ),
                  if (postImg == null)
                    GestureDetector(
                      onTap: () => _addImage(context),
                      child: const Icon(
                        Icons.add_rounded,
                        size: 34,
                        color: botticelli,
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: () => _addImage(context),
                      child: const Icon(
                        Icons.change_circle,
                        size: 34,
                        color: botticelli,
                      ),
                    ),
                ],
              ),
              const Spacer(flex: 1),
              TextContainer(controller: _captionCont, hintText: 'Write a caption...', textInputType: TextInputType.multiline),
              const Spacer(flex: 5),
              GestureDetector(
                onTap: () {
                  if (postImg != null) {
                    post(_user.userId, _user.userName, postImg!, _user.userPicUrl);
                  } else {
                    bildirim('select an image', context);
                  }
                },
                child: Container(
                  child: isLoading
                      ? const CircularProgressIndicator(
                          backgroundColor: balihai,
                          color: botticelli,
                          strokeWidth: 2,
                        )
                      : const Text(
                          'POST',
                          style: TextStyle(fontSize: 21, color: botticelli, fontWeight: FontWeight.w500),
                        ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: ebonyclay,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: botticelli.withOpacity(.25)),
                    boxShadow: [
                      BoxShadow(
                        color: balihai.withOpacity(.15),
                        offset: const Offset(0, 0),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
