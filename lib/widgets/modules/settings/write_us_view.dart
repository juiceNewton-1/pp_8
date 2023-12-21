import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_8/generated/assets.gen.dart';
import 'package:pp_8/generated/locale_keys.g.dart';
import 'package:pp_8/helpers/email_helper.dart';
import 'package:pp_8/widgets/components/app_button.dart';
import 'package:pp_8/widgets/components/app_text_field.dart';

class WriteUsView extends StatefulWidget {
  const WriteUsView({super.key});

  @override
  State<WriteUsView> createState() => _WriteUsViewState();
}

class _WriteUsViewState extends State<WriteUsView> {
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  var _isButtonEnabled = false;

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _send() async => await EmailHelper.launchEmailSubmission(
        toEmail: 'ngocthiminh935@gmail.com',
        subject: _subjectController.text,
        body: _messageController.text,
        errorCallback: () {},
        doneCallback: Navigator.of(context).pop,
      );

  void _onChanged(String query) => setState(() => _isButtonEnabled =
      _subjectController.text.isNotEmpty && _messageController.text.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Assets.icons.chevronLeft.svg(),
          onPressed: Navigator.of(context).pop,
        ),
        title: Text(LocaleKeys.support_title.tr()),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.support_write_subject.tr(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 5),
            SizedBox(
              height: 46,
              child: AppTextField(
                placeholder: LocaleKeys.support_subject.tr(),
                controller: _subjectController,
                onChanged: _onChanged,
              ),
            ),
            SizedBox(height: 16),
            Text(
              LocaleKeys.support_write_comment.tr(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 5),
            SizedBox(
              height: 122,
              child: AppTextField(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                placeholder: LocaleKeys.support_text.tr(),
                textAlignVertical: TextAlignVertical.top,
                controller: _messageController,
                onChanged: _onChanged,
              ),
            ),
            Spacer(),
            AppButton(
              label: LocaleKeys.support_send.tr(),
              onPressed: _isButtonEnabled ? _send : null,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

