import 'package:objectbox/objectbox.dart';

@Entity()
class TokenDto {
  @Id()
  int id;
  @Index()
  String text;

  TokenDto({
    this.id = 0,
    required this.text,
  });
}
