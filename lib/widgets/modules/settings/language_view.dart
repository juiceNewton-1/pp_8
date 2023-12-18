import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_8/generated/assets.gen.dart';
import 'package:pp_8/generated/locale_keys.g.dart';
import 'package:pp_8/helpers/constants.dart';
import 'package:pp_8/models/language.dart';
import 'package:pp_8/widgets/components/app_button.dart';

class LanguageView extends StatefulWidget {
  const LanguageView({super.key});

  @override
  State<LanguageView> createState() => _LanguageViewState();
}

class _LanguageViewState extends State<LanguageView> {
  Language? _selectedLanguage;

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _selectedLanguage = Constants.languages.firstWhere((element) =>
            element.locale.languageCode == context.locale.languageCode);
      });
    });
  }

  void _selectLanguage(Language language) {
    setState(() {
      _selectedLanguage = language;
    });
  }

  void _changeLanguage() {
    setState(() {
      context.setLocale(_selectedLanguage!.locale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: AppButton(
          label: LocaleKeys.change_action.tr(),
          onPressed: _changeLanguage,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Assets.icons.chevronLeft.svg(),
          onPressed: Navigator.of(context).pop,
        ),
        title: Text(LocaleKeys.change_language_title.tr()),
      ),
      body: ListView.separated(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 10,
          bottom: 80,
        ),
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final language = Constants.languages[index];
          return _LanguageTile(
            language: language,
            isSelected: language == _selectedLanguage,
            onPressed: () => _selectLanguage(language),
          );
        },
        separatorBuilder: (context, index) => SizedBox(height: 10),
        itemCount: Constants.languages.length,
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final Language language;
  final bool isSelected;
  final VoidCallback? onPressed;
  const _LanguageTile({
    required this.language,
    required this.isSelected,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        height: 70,
        padding: EdgeInsets.only(left: 26, right: 18),
        width: double.infinity,
        decoration: BoxDecoration(
          border: isSelected
              ? Border.all(color: Theme.of(context).colorScheme.primary)
              : null,
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Row(
          children: [
            Text(
              language.name,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Spacer(),
            if (isSelected) Assets.icons.selected.svg(),
          ],
        ),
      ),
    );
  }
}
