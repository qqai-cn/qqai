import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../components/video_player_public/public_video_player.dart';
import '../../../data/models/address_entity.dart';
import '../../../index/views/filter_page.dart';
import '../providers/fabu_goods_providers.dart';


class FabuGoodsPage extends ConsumerWidget {
  const FabuGoodsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fabuGoodsState = ref.watch(fabuGoodsProvider);
    final fabuGoodsNotifier = ref.read(fabuGoodsProvider.notifier);
    
    return ListView(
        padding: EdgeInsets.all(5),
        children: [
          Padding(
            padding: EdgeInsets.only(left: 5, right: 5, top: 5),
            child: Wrap(
              children: [
                ...fabuGoodsState.files.map(
                  (XFile file) => Container(
                    padding: EdgeInsets.all(5),
                    width: 0.3.sh,
                    height: 0.3.sh,
                    // width: fabuGoodsState.videoFiles.isEmpty ? 0.3.sw : 300,
                    // height: fabuGoodsState.videoFiles.isEmpty ? 0.3.sw : 300,
                    child: Stack(
                      children: [
                        fabuGoodsState.videoFiles.isEmpty
                            ? Positioned.fill(
                                child: kIsWeb
                                    ? Image.network(
                                        // width: 0.3.sw,
                                        // height: 0.3.sw,
                                        file.path,
                                        fit: BoxFit.fill,
                                      )
                                    : Image.file(File(file.path)),
                              )
                            : Positioned.fill(
                                child: PublicVideoPlayer(),
                              ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: IconButton.filled(
                              onPressed: () {
                                fabuGoodsNotifier.clearList(file);
                              },
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: fabuGoodsState.files.length < 6 &&
                      fabuGoodsState.videoFiles.isEmpty,
                  child: InkWell(
                    onTap: () {
                      _openImageFile(context, ref).then(
                          (value) => {fabuGoodsNotifier.selectFile(value, context)});
                    },
                    child: Icon(
                      Icons.add_box,
                      size: 0.3.sh,
                      color: Colors.black12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          TextField(
            minLines: 1,
            maxLines: 2,
            maxLength: 100,
            controller: fabuGoodsState.titleController,
            style: TextStyle(fontSize: 18),
            decoration: InputDecoration(
              ///设置输入文本框的提示文字
              ///输入框获取焦点时 并且没有输入文字时
              // hintText: "这一刻的想法...",
              ///设置输入文本框的提示文字的样式
              hintStyle: TextStyle(
                color: Colors.grey,
                textBaseline: TextBaseline.ideographic,
              ),

              ///输入框内的提示 输入框没有获取焦点时显示
              labelText: "商品标题",
              labelStyle: TextStyle(color: Colors.grey),

              ///输入框获取焦点时才会显示出来 输入文本的前面
              prefixText: "标题：",
              prefixStyle: TextStyle(color: Colors.blue),

              ///输入文字后面的小图标
              suffixIcon: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  fabuGoodsState.titleController.clear();
                },
              ),

              ///设置边框
              ///   InputBorder.none 无下划线
              ///   OutlineInputBorder 上下左右 都有边框
              ///   UnderlineInputBorder 只有下边框  默认使用的就是下边框
              border: OutlineInputBorder(
                ///设置边框四个角的弧度
                borderRadius: BorderRadius.all(Radius.circular(10)),

                ///用来配置边框的样式
                borderSide: BorderSide(
                  ///设置边框的颜色
                  color: Colors.red,

                  ///设置边框的粗细
                  width: 1.0,
                ),
              ),

              ///设置输入框可编辑时的边框样式
              enabledBorder: OutlineInputBorder(
                ///设置边框四个角的弧度
                borderRadius: BorderRadius.all(Radius.circular(10)),

                ///用来配置边框的样式
                borderSide: BorderSide(
                  ///设置边框的颜色
                  color: Colors.grey,

                  ///设置边框的粗细
                  width: 1.0,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                ///设置边框四个角的弧度
                borderRadius: BorderRadius.all(Radius.circular(10)),

                ///用来配置边框的样式
                borderSide: BorderSide(
                  ///设置边框的颜色
                  color: Colors.red,

                  ///设置边框的粗细
                  width: 1.0,
                ),
              ),

              ///用来配置输入框获取焦点时的颜色
              focusedBorder: OutlineInputBorder(
                ///设置边框四个角的弧度
                borderRadius: BorderRadius.all(Radius.circular(20)),

                ///用来配置边框的样式
                borderSide: BorderSide(
                  ///设置边框的颜色
                  color: Colors.blue,

                  ///设置边框的粗细
                  width: 1.0,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          TextField(
            minLines: 1,
            maxLines: 1,
            maxLength: 20,
            controller: fabuGoodsState.contentController,
            style: TextStyle(fontSize: 18),
            decoration: InputDecoration(
              ///设置输入文本框的提示文字
              ///输入框获取焦点时 并且没有输入文字时
              // hintText: "这一刻的想法...",
              ///设置输入文本框的提示文字的样式
              hintStyle: TextStyle(
                color: Colors.grey,
                textBaseline: TextBaseline.ideographic,
              ),

              ///输入框内的提示 输入框没有获取焦点时显示
              labelText: "价格",
              labelStyle: TextStyle(color: Colors.grey),

              ///输入框获取焦点时才会显示出来 输入文本的前面
              prefixText: "¥：",
              prefixStyle: TextStyle(color: Colors.blue),

              ///输入文字后面的小图标
              suffixIcon: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  fabuGoodsState.contentController.clear();
                },
              ),

              ///设置边框
              ///   InputBorder.none 无下划线
              ///   OutlineInputBorder 上下左右 都有边框
              ///   UnderlineInputBorder 只有下边框  默认使用的就是下边框
              border: OutlineInputBorder(
                ///设置边框四个角的弧度
                borderRadius: BorderRadius.all(Radius.circular(10)),

                ///用来配置边框的样式
                borderSide: BorderSide(
                  ///设置边框的颜色
                  color: Colors.red,

                  ///设置边框的粗细
                  width: 1.0,
                ),
              ),

              ///设置输入框可编辑时的边框样式
              enabledBorder: OutlineInputBorder(
                ///设置边框四个角的弧度
                borderRadius: BorderRadius.all(Radius.circular(10)),

                ///用来配置边框的样式
                borderSide: BorderSide(
                  ///设置边框的颜色
                  color: Colors.grey,

                  ///设置边框的粗细
                  width: 1.0,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                ///设置边框四个角的弧度
                borderRadius: BorderRadius.all(Radius.circular(10)),

                ///用来配置边框的样式
                borderSide: BorderSide(
                  ///设置边框的颜色
                  color: Colors.red,

                  ///设置边框的粗细
                  width: 1.0,
                ),
              ),

              ///用来配置输入框获取焦点时的颜色
              focusedBorder: OutlineInputBorder(
                ///设置边框四个角的弧度
                borderRadius: BorderRadius.all(Radius.circular(20)),

                ///用来配置边框的样式
                borderSide: BorderSide(
                  ///设置边框的颜色
                  color: Colors.blue,

                  ///设置边框的粗细
                  width: 1.0,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          TextField(
            minLines: 5,
            maxLines: 10,
            maxLength: 1000,
            controller: fabuGoodsState.contentController,
            style: TextStyle(fontSize: 18),
            decoration: InputDecoration(
              ///设置输入文本框的提示文字
              ///输入框获取焦点时 并且没有输入文字时
              // hintText: "这一刻的想法...",
              ///设置输入文本框的提示文字的样式
              hintStyle: TextStyle(
                color: Colors.grey,
                textBaseline: TextBaseline.ideographic,
              ),

              ///输入框内的提示 输入框没有获取焦点时显示
              labelText: "商品描述",
              labelStyle: TextStyle(color: Colors.grey),

              ///输入框获取焦点时才会显示出来 输入文本的前面
              prefixText: "描述：",
              prefixStyle: TextStyle(color: Colors.blue),

              ///输入文字后面的小图标
              suffixIcon: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  fabuGoodsState.contentController.clear();
                },
              ),

              ///设置边框
              ///   InputBorder.none 无下划线
              ///   OutlineInputBorder 上下左右 都有边框
              ///   UnderlineInputBorder 只有下边框  默认使用的就是下边框
              border: OutlineInputBorder(
                ///设置边框四个角的弧度
                borderRadius: BorderRadius.all(Radius.circular(10)),

                ///用来配置边框的样式
                borderSide: BorderSide(
                  ///设置边框的颜色
                  color: Colors.red,

                  ///设置边框的粗细
                  width: 1.0,
                ),
              ),

              ///设置输入框可编辑时的边框样式
              enabledBorder: OutlineInputBorder(
                ///设置边框四个角的弧度
                borderRadius: BorderRadius.all(Radius.circular(10)),

                ///用来配置边框的样式
                borderSide: BorderSide(
                  ///设置边框的颜色
                  color: Colors.grey,

                  ///设置边框的粗细
                  width: 1.0,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                ///设置边框四个角的弧度
                borderRadius: BorderRadius.all(Radius.circular(10)),

                ///用来配置边框的样式
                borderSide: BorderSide(
                  ///设置边框的颜色
                  color: Colors.red,

                  ///设置边框的粗细
                  width: 1.0,
                ),
              ),

              ///用来配置输入框获取焦点时的颜色
              focusedBorder: OutlineInputBorder(
                ///设置边框四个角的弧度
                borderRadius: BorderRadius.all(Radius.circular(20)),

                ///用来配置边框的样式
                borderSide: BorderSide(
                  ///设置边框的颜色
                  color: Colors.blue,

                  ///设置边框的粗细
                  width: 1.0,
                ),
              ),
            ),
          ),
          Divider(
            height: 1,
            color: Colors.black12,
            indent: 20,
            endIndent: 20,
          ),
          InkWell(
            onTap: () {
              showModalBottomSheet(
                  constraints: BoxConstraints(maxHeight: 0.8.sh),
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext build) {
                    return Padding(
                      padding: EdgeInsets.only(top: 50.h),
                      child: ListView.separated(
                        itemCount: fabuGoodsState.addressList.length,
                        itemBuilder: (BuildContext context, int index) {
                          AddressEntity addressEntity =
                              fabuGoodsState.addressList[index];
                          String detail = addressEntity.detail;
                          String distance = addressEntity.distance;
                          return ListTile(
                            title: Text(addressEntity.name),
                            subtitle: index == 0
                                ? null
                                : Text(
                                    '$detail | $distance',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                            trailing: fabuGoodsState.selAddressEntity?.name ==
                                    addressEntity.name
                                ? const Icon(Icons.check)
                                : null,
                            onTap: () {
                              fabuGoodsNotifier.setAddress(addressEntity);
                              Navigator.pop(context);
                            },
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(height: 1.0, color: Colors.grey),
                      ),
                    );
                  });
            },
            child: fabuGoodsState.selAddressEntity == null
                ? const ListTile(
                    leading: Icon(Icons.add_location),
                    title: Text('所在位置'),
                    trailing: Icon(Icons.chevron_right),
                  )
                : ListTile(
                    leading: const Icon(Icons.category),
                    title: Text(fabuGoodsState.selAddressEntity!.name),
                    trailing: const Icon(Icons.chevron_right),
                  ),
          ),
          Divider(
            height: 1,
            color: Colors.black12,
            indent: 20,
            endIndent: 20,
          ),
          InkWell(
            onTap: () {
              showModalBottomSheet(
                  constraints: BoxConstraints(maxHeight: 0.8.sh),
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext build) {
                    return FilterPage(fabuGoodsState.huatiSel);
                  }).then((value) {
                if (value != null) {
                  fabuGoodsNotifier.setHuati(value);
                }
              });
            },
            child: ListTile(
              leading: const Icon(Icons.category),
              title: fabuGoodsState.huatiSel.isEmpty
                  ? const Text('分类')
                  : Text(fabuGoodsState.huatiSel.values.join(",")),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
          Divider(
            height: 1,
            color: Colors.black12,
            indent: 20,
            endIndent: 20,
          ),
        ],
      );
  }

  Future<List<XFile>> _openImageFile(BuildContext context, WidgetRef ref) async {
    // #docregion MultiOpen
    const XTypeGroup jpgsTypeGroup = XTypeGroup(
      label: 'JPEGs',
      extensions: <String>['jpg', 'jpeg'],
    );
    const XTypeGroup pngTypeGroup = XTypeGroup(
      label: 'PNGs',
      extensions: <String>['png'],
    );
    List<String> videoList = ['mp3', 'mp4'];
    const XTypeGroup videoTypeGroup = XTypeGroup(
      label: 'video',
      extensions: <String>['mp3', 'mp4'],
    );
    final List<XFile> files = await openFiles(acceptedTypeGroups: <XTypeGroup>[
      jpgsTypeGroup,
      pngTypeGroup,
      videoTypeGroup
    ]);
    // #enddocregion MultiOpen
    if (files.isEmpty) {
      // Operation was canceled by the user.
      return Future.value([]);
    }
    final videoFiles = <XFile>[];
    files.forEach((element) {
      String suf = element.name.split(".").last;
      if (videoList.contains(suf)) {
        videoFiles.add(element);
        return;
      }
    });

    if (videoFiles.isNotEmpty) {
      final notifier = ref.read(fabuGoodsProvider.notifier);
      notifier.addVideoFiles(videoFiles);
    }

    if (context.mounted) {
      final state = ref.read(fabuGoodsProvider);
      return Future.value(
          state.videoFiles.isNotEmpty ? state.videoFiles : files);
    }
    return Future.value([]);
  }
}
