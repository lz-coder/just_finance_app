import 'package:flutter/material.dart';

class CreateTransactionButtons extends StatelessWidget {
  final Function dialogCallback;

  const CreateTransactionButtons({
    super.key,
    required this.dialogCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 54,
          child: FloatingActionButton(
            heroTag: "button01",
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                topLeft: Radius.circular(10),
              ),
            ),
            backgroundColor: const Color.fromARGB(255, 216, 94, 94),
            onPressed: () => dialogCallback(false),
            child: const Icon(Icons.remove),
          ),
        ),
        SizedBox(
          height: 64,
          width: 64,
          child: FloatingActionButton(
            heroTag: "button02",
            backgroundColor: const Color.fromARGB(255, 94, 216, 94),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                topLeft: Radius.circular(8),
                bottomRight: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            onPressed: () async {
              dialogCallback(true);
            },
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
