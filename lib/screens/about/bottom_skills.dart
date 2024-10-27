import 'package:portfolio/imports.dart';

class BottomSkillsRow extends StatelessWidget {
  const BottomSkillsRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 15.r,
        runSpacing: 10.r,
        children: const [
          SkillTile(
            tileColor: Color(0xff00ADD8),
            tileText: AppStrings.flutter,
          ),
          SkillTile(
            tileColor: Color(0xff234A84),
            tileText: AppStrings.bloc,
          ),
          SkillTile(
            tileColor: Color(0xff61DAF6),
            tileText: AppStrings.dart,
          ),
          SkillTile(
            tileColor: Color(0xffFF9900),
            tileText: AppStrings.graphql,
          ),
          SkillTile(
            tileColor: Color(0xff4285F4),
            tileText: AppStrings.android,
          ),
          SkillTile(
            tileColor: Color(0xff326CE5),
            tileText: AppStrings.ios,
          ),
          SkillTile(
            tileColor: Color(0xff0DB7ED),
            tileText: AppStrings.apiIntegration,
          ),
          SkillTile(
            tileColor: Color(0xff7B42BC),
            tileText: AppStrings.ciCd,
          ),
          SkillTile(
            tileColor: Color(0xff199BFC),
            tileText: AppStrings.provider,
          ),
          SkillTile(
            tileColor: Color(0xffD82C20),
            tileText: AppStrings.firebase,
          ),
          SkillTile(
            tileColor: Color(0xffE535AB),
            tileText: AppStrings.git,
          ),
          SkillTile(
            tileColor: Color(0xff68A063),
            tileText: AppStrings.mvvm,
          ),
        ],
      ),
    );
  }
}