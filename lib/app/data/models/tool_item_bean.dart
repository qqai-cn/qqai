class ToolItemBean {
  final String imageUrl;
  final String title;
  final String subTitle;
  final String desc;
  final String indexLetter;
  final String clickUrl;

  ToolItemBean(
      {required this.imageUrl,
      required this.title,
      required this.subTitle,
      required this.desc,
      required this.indexLetter,
      required this.clickUrl,
      });
}

List<ToolItemBean> datas = [
  ToolItemBean(
      imageUrl: "imgs/date.svg",
      title: "时间转换",
      subTitle: "时间转换工具",
      desc: "时间和时间戳的互相转换",
      indexLetter: "shijian",clickUrl: ""),
];
