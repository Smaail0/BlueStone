// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stegmessage/models/user_model.dart';
import 'package:stegmessage/providers/authentication_provider.dart';
import 'package:stegmessage/utilities/global_methods.dart';

class GroupAppBar extends StatefulWidget {
  const GroupAppBar({super.key, required this.groupID});

  final String groupID;

  @override
  State<GroupAppBar> createState() => _GroupAppBarState();
}

class _GroupAppBarState extends State<GroupAppBar> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: context
          .read<AuthenticationProvider>()
          .userStream(userID: widget.groupID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Une erreur est survenue. Veuillez réessayer.'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data?.data() == null) {
          return const Center(
            child: Text('Données du groupe introuvables.'),
          );
        }

        final groupModel =
            UserModel.fromMap(snapshot.data!.data() as Map<String, dynamic>);

        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                // Naviguer vers l'écran du profil du groupe
                GlobalMethods.navigateTo(
                  context: context,
                  routeName: '/groupProfile',
                  arguments: {'groupID': widget.groupID},
                );
              },
              child: userImageWidget(
                imageUrl: groupModel.image,
                radius: 20,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    groupModel.name,
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    groupModel.description.isNotEmpty
                        ? groupModel.description
                        : 'Aucune description disponible',
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                // Ajouter une action (par exemple, afficher des options pour le groupe)
              },
              icon: const Icon(Icons.more_vert),
            ),
          ],
        );
      },
    );
  }
}

class GlobalMethods {
  /// Navigue vers une route spécifique avec des arguments optionnels
  static void navigateTo({
    required BuildContext context,
    required String routeName,
    Object? arguments,
  }) {
    Navigator.pushNamed(
      context,
      routeName,
      arguments: arguments,
    );
  }

  /// Affiche une boîte de dialogue de confirmation
  static Future<void> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              if (onCancel != null) onCancel();
            },
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onConfirm();
            },
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }
}

Widget userImageWidget({
  required String imageUrl,
  double radius = 20,
  VoidCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: CircleAvatar(
      radius: radius,
      backgroundImage: imageUrl.isNotEmpty
          ? NetworkImage(imageUrl)
          : const AssetImage('assets/images/default_avatar.png')
              as ImageProvider,
    ),
  );
}

class UserModel {
  final String name;
  final String image;
  final String description;

  UserModel({
    required this.name,
    required this.image,
    required this.description,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? 'Nom inconnu',
      image: map['image'] ?? '',
      description: map['description'] ?? '',
    );
  }
}
