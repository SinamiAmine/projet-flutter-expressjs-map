import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class AnimatedDialogAdd extends StatelessWidget {
  const AnimatedDialogAdd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      text: 'Succes Dialog',
      color: Colors.green,
      pressEvent: () {
        AwesomeDialog(
            context: context,
            animType: AnimType.LEFTSLIDE,
            headerAnimationLoop: false,
            dialogType: DialogType.SUCCES,
            showCloseIcon: true,
            title: 'Succes',
            desc:
                'Dialog description here..................................................',
            btnOkOnPress: () {
              debugPrint('OnClcik');
            },
            btnOkIcon: Icons.check_circle,
            onDissmissCallback: (type) {
              debugPrint('Dialog Dissmiss from callback $type');
            })
          ..show();
      },
    );
  }
}
