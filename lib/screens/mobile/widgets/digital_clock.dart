import 'package:intl/intl.dart';
import 'package:portfolio/imports.dart';

class DigitalCLock extends StatelessWidget {
  const DigitalCLock({super.key, required this.dateNotifier});

  final ValueNotifier<DateTime> dateNotifier;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ValueListenableBuilder(
        valueListenable: dateNotifier,
        builder: (context, value, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  DateFormat("EEE, d MMM").format(value),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
              Center(
                child: Text(
                  DateFormat("hh:mm").format(
                    value,
                  ),
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}