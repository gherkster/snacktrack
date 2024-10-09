import 'package:objectbox/objectbox.dart';

@Entity()
class TokenDto {
  @Id()
  int id;
  String text;

  TokenDto({
    this.id = 0,
    required this.text,
  });
}
