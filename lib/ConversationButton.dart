import 'package:flutter/material.dart';

class ConversationButton extends StatelessWidget{
  const ConversationButton(
      this.conversationID,
      this.title,
      this.lastMessage,
      {Key? key}
      ) : super(key: key);

  final String conversationID;
  final String title;
  final String lastMessage;

  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        const Padding(padding: EdgeInsets.all(5)),
        SizedBox(
          height: 60,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (){},
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                    child: Text(title)
                ),
                const Padding(padding: EdgeInsets.all(10)),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(lastMessage)
                )
              ]
            )
            )
        )
      ]
    );
  }
}