import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_8/generated/assets.gen.dart';
import 'package:pp_8/routes/route_names.dart';
import 'package:pp_8/widgets/components/app_button.dart';
import 'package:pp_8/widgets/components/app_text_field.dart';

class WriteUsView extends StatefulWidget {
  const WriteUsView({super.key});

  @override
  State<WriteUsView> createState() => _WriteUsViewState();
}

class _WriteUsViewState extends State<WriteUsView> {
  final _emaiController = TextEditingController();
  final _messageController = TextEditingController();

  var _isButtonEnabled = false;

  @override
  void dispose() {
    _emaiController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _send() {
    setState(() {
      _emaiController.clear();
      _messageController.clear();
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _MessageSentDialog(),
    );
  }

  void _onChanged(String query) => setState(() => _isButtonEnabled =
      _isEmail(_emaiController.text) && _messageController.text.isNotEmpty);

  bool _isEmail(String em) {
    final regExp = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

    return regExp.hasMatch(em);
  }

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
        title: Text('Write to us'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter your email',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 5),
            SizedBox(
              height: 46,
              child: AppTextField(
                placeholder: 'Email',
                controller: _emaiController,
                onChanged: _onChanged,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Write your comment',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 5),
            SizedBox(
              height: 122,
              child: AppTextField(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                placeholder: 'Text',
                textAlignVertical: TextAlignVertical.top,
                controller: _messageController,
                onChanged: _onChanged,
              ),
            ),
            Spacer(),
            AppButton(
              label: 'Send',
              onPressed: _isButtonEnabled ? _send : null,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _MessageSentDialog extends StatelessWidget {
  const _MessageSentDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      insetPadding: EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: EdgeInsets.only(left: 18, right: 18, top: 16, bottom: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Assets.images.success.image(width: 105, height: 105),
            SizedBox(height: 12),
            Text(
              'Great! You have successfully sent\nus your message',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 17),
            AppButton(
              label: 'Excellent',
              onPressed: () => Navigator.of(context).popUntil(
                (route) => route.settings.name == RouteNames.settings,
              ),
            )
          ],
        ),
      ),
    );
  }
}
