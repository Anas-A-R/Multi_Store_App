import 'package:flutter/material.dart';

class YellowDivider extends StatelessWidget {
  const YellowDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Divider(
        color: Colors.yellow,
        thickness: 1,
      ),
    );
  }
}

class RepeatedListTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final Function()? onPressed;
  final IconData icon;
  const RepeatedListTile({
    super.key,
    required this.title,
    this.subTitle = '',
    this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subTitle),
      ),
    );
  }
}

class ProfileHeaderLabel extends StatelessWidget {
  final String label;
  const ProfileHeaderLabel({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              thickness: 1,
              color: Colors.grey,
            ),
          ),
          Text(
            '  $label  ',
            style: const TextStyle(color: Colors.grey, fontSize: 20),
          ),
          const SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              thickness: 1,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
