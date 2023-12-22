import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_8/generated/assets.gen.dart';
import 'package:pp_8/helpers/text_helper.dart';
import 'package:pp_8/models/arguments.dart';

class AgreementView extends StatelessWidget {
  final AgreementViewArguments arguments;
  const AgreementView({super.key, required this.arguments});

  factory AgreementView.create(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as AgreementViewArguments;
    return AgreementView(arguments: arguments);
  }

  AgreementType get _agreementType => arguments.agreementType;

  String get _agreementText => _agreementType == AgreementType.privacy
      ? TextHelper.privacy
      : TextHelper.terms;

  String get _title => _agreementType == AgreementType.privacy
      ? 'Privacy Policy'
      : 'Terms Of Use';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CupertinoButton(
          child: Assets.icons.close.svg(),
          onPressed: Navigator.of(context).pop,
          padding: EdgeInsets.zero,
        ),
        title: Text(
          _title,
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Text(
          _agreementText,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}

enum AgreementType {
  privacy,
  terms,
}
