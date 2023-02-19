abstract class DropDownBase {
  abstract final int id;

  abstract final String title;
}

class DropBase extends DropDownBase {
  @override
  final int id;

  @override
  final String title;

  DropBase(this.id, this.title);

  DropBase.fromJson(row)
      : id = row['id'],
        title = row['title'];
}
