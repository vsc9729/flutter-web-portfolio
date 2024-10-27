import 'package:intl/intl.dart';
import 'package:portfolio/imports.dart';

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    required this.dateNotifier,
  });

  final ValueNotifier<DateTime> dateNotifier;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ValueListenableBuilder(
          valueListenable: dateNotifier,
          builder: (context, value, child) {
            return Text(
              DateFormat('h:mm').format(value),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            );
          },
        ),
        const Spacer(),
        SizedBox(
          width: 10.w,
        ),
        SizedBox(
          width: 10.w,
        ),
        const Icon(
          Icons.signal_cellular_alt,
          size: 15,
          color: Colors.white,
        ),
        const Icon(
          Icons.battery_full,
          size: 15,
          color: Colors.white,
        ),
      ],
    );
  }
}