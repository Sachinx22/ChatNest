import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatScreen extends StatefulWidget {
  final String userName;

  const ChatScreen({
    super.key,
    required this.userName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController =
      TextEditingController();

  final ScrollController scrollController =
      ScrollController();

  String? replyingTo;
  int? editingIndex;

  bool isTyping = false;

  // ------------------------------------------------------------
  // SAMPLE CONVERSATION
  // ------------------------------------------------------------

  late List<Map<String, dynamic>> messages;

  @override
  void initState() {
    super.initState();

    messages = [
      {
        'message': 'Hey! How are you?',
        'isMe': false,
        'time': '10:30 AM',
        'status': 'read',
      },
      {
        'message': 'I am good! How about you?',
        'isMe': true,
        'time': '10:31 AM',
        'status': 'read',
      },
      {
        'message': 'I am doing great! 😊',
        'isMe': false,
        'time': '10:32 AM',
        'status': 'read',
      },
      {
        'message': 'Are you free today?',
        'isMe': false,
        'time': '10:35 AM',
        'status': 'read',
      },
    ];
  }

  // ------------------------------------------------------------
  // VOICE CALL
  // ------------------------------------------------------------

  void startVoiceCall() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 45,
                child: Icon(
                  Icons.person,
                  size: 50,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                widget.userName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Calling...',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 25),

              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.red,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  icon: const Icon(
                    Icons.call_end,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              const Text('End Call'),
            ],
          ),
        );
      },
    );
  }

  // ------------------------------------------------------------
  // VIDEO CALL
  // ------------------------------------------------------------

  void startVideoCall() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius:
                      BorderRadius.circular(15),
                ),
                child: const Center(
                  child: Icon(
                    Icons.videocam,
                    color: Colors.white,
                    size: 70,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                widget.userName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Starting video call...',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 25),

              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.red,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  icon: const Icon(
                    Icons.call_end,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              const Text('End Call'),
            ],
          ),
        );
      },
    );
  }

  // ------------------------------------------------------------
  // SEND MESSAGE
  // ------------------------------------------------------------

  void sendMessage() {
    final String message =
        messageController.text.trim();

    if (message.isEmpty) {
      return;
    }

    // ----------------------------------------------------------
    // EDIT EXISTING MESSAGE
    // ----------------------------------------------------------

    if (editingIndex != null) {
      setState(() {
        messages[editingIndex!]['message'] =
            message;

        editingIndex = null;
      });

      messageController.clear();
      return;
    }

    // ----------------------------------------------------------
    // SEND NEW MESSAGE
    // ----------------------------------------------------------

    final int newMessageIndex =
        messages.length;

    setState(() {
      messages.add({
        'message': message,
        'isMe': true,
        'time': 'Now',
        'status': 'sent',
        'replyTo': replyingTo,
      });

      replyingTo = null;
    });

    messageController.clear();

    scrollToBottom();

    // ----------------------------------------------------------
    // STEP 1 → SINGLE TICK
    // ----------------------------------------------------------

    Future.delayed(
      const Duration(milliseconds: 700),
      () {
        if (!mounted) {
          return;
        }

        setState(() {
          if (newMessageIndex <
              messages.length) {
            messages[newMessageIndex]['status'] =
                'delivered';
          }
        });

        // ------------------------------------------------------
        // STEP 2 → DOUBLE TICK + TYPING
        // ------------------------------------------------------

        Future.delayed(
          const Duration(milliseconds: 500),
          () {
            if (!mounted) {
              return;
            }

            setState(() {
              if (newMessageIndex <
                  messages.length) {
                messages[newMessageIndex]['status'] =
                    'read';
              }

              isTyping = true;
            });

            scrollToBottom();

            // --------------------------------------------------
            // STEP 3 → AUTO REPLY
            // --------------------------------------------------

            generateAutoReply(message);
          },
        );
      },
    );
  }

  // ------------------------------------------------------------
  // SMART AUTO REPLY
  // ------------------------------------------------------------

  void generateAutoReply(String message) {
    final String text =
        message.toLowerCase();

    String reply;

    if (text.contains('hi') ||
        text.contains('hello') ||
        text.contains('hey')) {
      reply = 'Hey! 😊 How are you?';
    } else if (text.contains('how are you') ||
        text.contains('how r u')) {
      reply =
          'I am good! What about you? 😊';
    } else if (text.contains('good morning')) {
      reply =
          'Good morning! Have a great day 😊';
    } else if (text.contains('good night')) {
      reply =
          'Good night! Sleep well 😴';
    } else if (text.contains('where are you') ||
        text.contains('where r u')) {
      reply =
          'I am nearby. What\'s up?';
    } else if (text.contains('are you coming') ||
        text.contains('coming')) {
      reply =
          'Yes, I will be there soon.';
    } else if (text.contains('college') ||
        text.contains('class')) {
      reply =
          'Yes, I will be there for the class.';
    } else if (text.contains('assignment')) {
      reply =
          'Not yet 😅 I am still working on it.';
    } else if (text.contains('project')) {
      reply =
          'Sure! Let\'s discuss the project.';
    } else if (text.contains('help')) {
      reply =
          'Sure! Tell me what you need.';
    } else if (text.contains('thank')) {
      reply =
          'You\'re welcome! 😊';
    } else if (text.contains('sorry')) {
      reply =
          'It\'s okay, no problem! 😊';
    } else if (text.contains('bye')) {
      reply =
          'Okay, bye! Talk to you later 👋';
    } else if (text.contains('nice') ||
        text.contains('great') ||
        text.contains('awesome')) {
      reply =
          'Yes! That sounds great 😄';
    } else if (text.contains('?')) {
      reply =
          'Hmm, let me think about that 🤔';
    } else {
      reply = getGeneralReply();
    }

    Future.delayed(
      const Duration(seconds: 2),
      () {
        if (!mounted) {
          return;
        }

        setState(() {
          isTyping = false;

          messages.add({
            'message': reply,
            'isMe': false,
            'time': 'Now',
            'status': 'read',
          });
        });

        scrollToBottom();
      },
    );
  }

  // ------------------------------------------------------------
  // GENERAL REPLY
  // ------------------------------------------------------------

  String getGeneralReply() {
    final List<String> replies = [
      'Got it 👍',
      'Okay, sounds good!',
      'Alright 😊',
      'Sure!',
      'Okay, I understand.',
      'That sounds interesting!',
      'Yes, absolutely.',
      'Hmm, okay 😄',
    ];

    final int index =
        DateTime.now().millisecondsSinceEpoch %
            replies.length;

    return replies[index];
  }

  // ------------------------------------------------------------
  // SCROLL TO BOTTOM
  // ------------------------------------------------------------

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (!scrollController.hasClients) {
          return;
        }

        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration:
              const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      },
    );
  }

  // ------------------------------------------------------------
  // MESSAGE OPTIONS
  // ------------------------------------------------------------

  void showMessageOptions(int index) {
    final bool isMyMessage =
        messages[index]['isMe'];

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading:
                    const Icon(Icons.reply),
                title:
                    const Text('Reply'),
                onTap: () {
                  setState(() {
                    replyingTo =
                        messages[index]['message'];

                    editingIndex = null;
                  });

                  Navigator.pop(context);
                },
              ),

              ListTile(
                leading:
                    const Icon(Icons.copy),
                title:
                    const Text('Copy'),
                onTap: () {
                  Clipboard.setData(
                    ClipboardData(
                      text:
                          messages[index]['message'],
                    ),
                  );

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content:
                          Text('Message copied'),
                    ),
                  );
                },
              ),

              if (isMyMessage)
                ListTile(
                  leading:
                      const Icon(Icons.edit),
                  title:
                      const Text('Edit'),
                  onTap: () {
                    Navigator.pop(context);

                    setState(() {
                      editingIndex = index;
                      replyingTo = null;

                      messageController.text =
                          messages[index]['message'];
                    });

                    messageController.selection =
                        TextSelection.fromPosition(
                      TextPosition(
                        offset:
                            messageController.text.length,
                      ),
                    );
                  },
                ),

              ListTile(
                leading:
                    const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                title:
                    const Text('Delete'),
                onTap: () {
                  Navigator.pop(context);

                  confirmDeleteMessage(index);
                },
              ),

              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  // ------------------------------------------------------------
  // DELETE MESSAGE
  // ------------------------------------------------------------

  void confirmDeleteMessage(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              const Text('Delete message?'),
          content:
              const Text(
            'Are you sure you want to delete this message?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  messages.removeAt(index);

                  if (editingIndex == index) {
                    editingIndex = null;
                    messageController.clear();
                  }
                });

                Navigator.pop(context);
              },
              child:
                  const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ------------------------------------------------------------
  // ATTACHMENT MENU
  // ------------------------------------------------------------

  void showAttachmentMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.all(20),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                const Text(
                  'Send Attachment',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceEvenly,
                  children: [
                    attachmentOption(
                      icon:
                          Icons.camera_alt,
                      label: 'Camera',
                    ),
                    attachmentOption(
                      icon: Icons.photo,
                      label: 'Gallery',
                    ),
                    attachmentOption(
                      icon: Icons
                          .insert_drive_file,
                      label: 'Document',
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget attachmentOption({
    required IconData icon,
    required String label,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);

        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              '$label option selected',
            ),
          ),
        );
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            child: Icon(icon),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // EMOJI
  // ------------------------------------------------------------

  void showEmojiMessage() {
    messageController.text += '😊';

    messageController.selection =
        TextSelection.fromPosition(
      TextPosition(
        offset:
            messageController.text.length,
      ),
    );
  }

  // ------------------------------------------------------------
  // CANCEL REPLY / EDIT
  // ------------------------------------------------------------

  void cancelCurrentAction() {
    setState(() {
      replyingTo = null;
      editingIndex = null;
      messageController.clear();
    });
  }

  // ------------------------------------------------------------
  // DISPOSE
  // ------------------------------------------------------------

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,

        title: Row(
          children: [
            const CircleAvatar(
              child: Icon(Icons.person),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.userName,
                    style:
                        const TextStyle(
                      fontSize: 17,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  Text(
                    isTyping
                        ? 'typing...'
                        : 'Online',
                    style: TextStyle(
                      fontSize: 12,
                      color: isTyping
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                          : null,
                    ),
                  ),
                ],
              ),
            ),

            // Voice Call
            IconButton(
              tooltip: 'Voice Call',
              onPressed: startVoiceCall,
              icon: const Icon(
                Icons.call,
              ),
            ),

            // Video Call
            IconButton(
              tooltip: 'Video Call',
              onPressed: startVideoCall,
              icon: const Icon(
                Icons.videocam,
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          // ----------------------------------------------------
          // MESSAGES
          // ----------------------------------------------------

          Expanded(
            child: ListView.builder(
              controller:
                  scrollController,
              padding:
                  const EdgeInsets.all(16),
              itemCount:
                  messages.length,
              itemBuilder:
                  (context, index) {
                final message =
                    messages[index];

                final bool isMe =
                    message['isMe'];

                final String messageText =
                    message['message'];

                final String? replyText =
                    message['replyTo'];

                return Align(
                  alignment: isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child:
                      GestureDetector(
                    onLongPress: () {
                      showMessageOptions(
                          index);
                    },
                    child: Container(
                      margin:
                          const EdgeInsets.only(
                        bottom: 10,
                      ),
                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      constraints:
                          const BoxConstraints(
                        maxWidth: 300,
                      ),
                      decoration:
                          BoxDecoration(
                        color: isMe
                            ? Theme.of(
                                context,
                              )
                                .colorScheme
                                .primary
                            : Theme.of(
                                context,
                              )
                                .colorScheme
                                .surfaceContainerHighest,
                        borderRadius:
                            BorderRadius.circular(
                          18,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .end,
                        children: [
                          if (replyText != null)
                            Container(
                              width:
                                  double.infinity,
                              margin:
                                  const EdgeInsets
                                      .only(
                                bottom: 8,
                              ),
                              padding:
                                  const EdgeInsets
                                      .all(8),
                              decoration:
                                  BoxDecoration(
                                color: isMe
                                    ? Colors.white
                                        .withOpacity(
                                        0.15,
                                      )
                                    : Colors.grey
                                        .withOpacity(
                                        0.15,
                                      ),
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  10,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 3,
                                    height: 35,
                                    decoration:
                                        BoxDecoration(
                                      color: isMe
                                          ? Colors
                                              .white
                                          : Theme.of(
                                              context,
                                            )
                                              .colorScheme
                                              .primary,
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        5,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                    width: 8,
                                  ),

                                  Expanded(
                                    child:
                                        Text(
                                      replyText,
                                      maxLines:
                                          2,
                                      overflow:
                                          TextOverflow
                                              .ellipsis,
                                      style:
                                          TextStyle(
                                        color: isMe
                                            ? Colors
                                                .white70
                                            : Colors
                                                .grey,
                                        fontSize:
                                            12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          Align(
                            alignment:
                                Alignment
                                    .centerLeft,
                            child: Text(
                              messageText,
                              style:
                                  TextStyle(
                                color: isMe
                                    ? Colors
                                        .white
                                    : null,
                                fontSize: 15,
                              ),
                            ),
                          ),

                          const SizedBox(
                              height: 4),

                          Row(
                            mainAxisSize:
                                MainAxisSize.min,
                            children: [
                              Text(
                                message['time'],
                                style:
                                    TextStyle(
                                  color: isMe
                                      ? Colors
                                          .white70
                                      : Colors
                                          .grey,
                                  fontSize: 10,
                                ),
                              ),

                              if (isMe) ...[
                                const SizedBox(
                                    width: 4),

                                buildMessageStatus(
                                  message[
                                      'status'],
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // ----------------------------------------------------
          // TYPING INDICATOR
          // ----------------------------------------------------

          if (isTyping)
            Container(
              width:
                  double.infinity,
              padding:
                  const EdgeInsets.only(
                left: 20,
                bottom: 6,
              ),
              child: Text(
                '${widget.userName} is typing...',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors
                      .grey
                      .shade600,
                  fontStyle:
                      FontStyle.italic,
                ),
              ),
            ),

          // ----------------------------------------------------
          // REPLY / EDIT PREVIEW
          // ----------------------------------------------------

          if (replyingTo != null ||
              editingIndex != null)
            Container(
              width:
                  double.infinity,
              padding:
                  const EdgeInsets
                      .symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration:
                  BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest,
                border:
                    Border(
                  top: BorderSide(
                    color: Colors
                        .grey
                        .shade300,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    editingIndex !=
                            null
                        ? Icons.edit
                        : Icons.reply,
                    size: 20,
                  ),

                  const SizedBox(
                      width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Text(
                          editingIndex !=
                                  null
                              ? 'Editing message'
                              : 'Replying to',
                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight
                                    .bold,
                            fontSize: 12,
                          ),
                        ),

                        if (replyingTo !=
                            null)
                          Text(
                            replyingTo!,
                            maxLines: 1,
                            overflow:
                                TextOverflow
                                    .ellipsis,
                            style:
                                const TextStyle(
                              fontSize: 12,
                            ),
                          ),

                        if (editingIndex !=
                            null)
                          Text(
                            messages[
                                    editingIndex!]
                                ['message'],
                            maxLines: 1,
                            overflow:
                                TextOverflow
                                    .ellipsis,
                            style:
                                const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed:
                        cancelCurrentAction,
                    icon:
                        const Icon(
                      Icons.close,
                    ),
                  ),
                ],
              ),
            ),

          // ----------------------------------------------------
          // INPUT AREA
          // ----------------------------------------------------

          Container(
            padding:
                const EdgeInsets.fromLTRB(
              8,
              8,
              8,
              8,
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed:
                      showAttachmentMenu,
                  icon:
                      const Icon(
                    Icons.attach_file,
                  ),
                ),

                Expanded(
                  child: TextField(
                    controller:
                        messageController,
                    textInputAction:
                        TextInputAction
                            .send,
                    onSubmitted: (_) {
                      sendMessage();
                    },
                    decoration:
                        InputDecoration(
                      hintText:
                          editingIndex !=
                                  null
                              ? 'Edit message...'
                              : 'Type a message...',

                      prefixIcon:
                          IconButton(
                        onPressed:
                            showEmojiMessage,
                        icon:
                            const Icon(
                          Icons
                              .emoji_emotions_outlined,
                        ),
                      ),

                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                          25,
                        ),
                      ),

                      contentPadding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 15,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                    width: 8),

                FloatingActionButton(
                  mini: true,
                  onPressed:
                      sendMessage,
                  child: Icon(
                    editingIndex !=
                            null
                        ? Icons.check
                        : Icons.send,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // MESSAGE STATUS ICON
  // ------------------------------------------------------------

  Widget buildMessageStatus(
      String? status) {
    if (status == 'sent') {
      return const Icon(
        Icons.done,
        size: 15,
        color: Colors.white70,
      );
    }

    if (status == 'delivered') {
      return const Icon(
        Icons.done_all,
        size: 15,
        color: Colors.white70,
      );
    }

    return const Icon(
      Icons.done_all,
      size: 15,
      color: Colors.lightBlueAccent,
    );
  }
}