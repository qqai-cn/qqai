import 'package:flutter/material.dart';
import 'package:qqai/config/theme/my_fonts.dart';

import '../../../../../constant/color_constant.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/features/fabu/data/models/topic_model.dart';

class FilterPage extends StatefulWidget {
  Map<int, String> commonNamesSel = {};
  final List<SkuuTopicResVO> topicList;

  FilterPage(this.commonNamesSel, this.topicList, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _FilterPage();
  }
}

class _FilterPage extends State<FilterPage> {
  late Map<int, String> _selectedTopics;

  @override
  void initState() {
    super.initState();
    _selectedTopics = Map.from(widget.commonNamesSel);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5), topRight: Radius.circular(5))),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            SizedBox(
              child: Text(
                '标签筛选',
                style: context.typo.sectionTitle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              height: 10,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8.0, // 主轴(水平)方向间距
                  runSpacing: 4.0, // 纵轴（垂直）方向间距
                  alignment: WrapAlignment.start, //沿主轴方向居中
                  children: <Widget>[
                    for (var topic in widget.topicList)
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedTopics.containsKey(topic.id)
                                  ? Colors.blue // 选中时显示蓝色
                                  : ColorConstant.lightBlue),
                          onPressed: () {
                            setState(() {
                              if (topic.id == null) return;
                              if (_selectedTopics.containsKey(topic.id)) {
                                _selectedTopics.remove(topic.id);
                              } else {
                                _selectedTopics[topic.id!] = topic.topicName ?? '';
                              }
                            });
                          },
                          icon: _selectedTopics.containsKey(topic.id)
                              ? Icon(Icons.check_circle, color: Colors.white)
                              : Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.grey,
                                ),
                          label: Text(
                            topic.topicName ?? '',
                            style: TextStyle(
                              color: _selectedTopics.containsKey(topic.id)
                                  ? Colors.white // 选中时文字白色
                                  : Colors.black87,
                            ),
                          ))
                  ],
                ),
              ),
            ),
            Container(
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedTopics.clear();
                          });
                        },
                        child: Container(
                          child: Center(
                            child: Text(
                              '重置',
                              style: context.typo.button,
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20))),
                          // color: Colors.red,
                        )),
                  ),
                  Expanded(
                    child: InkWell(
                        onTap: () {
                          Navigator.pop(context, _selectedTopics);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20))),
                          child: Center(
                            child: Text(
                              '完成',
                              style: context.typo.button,
                            ),
                          ),
                          // color: Colors.red,
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
