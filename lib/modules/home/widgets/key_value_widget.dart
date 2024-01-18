import 'package:flutter/material.dart';

class KeyValueWidget extends StatelessWidget {
  const KeyValueWidget({
    required this.name,
    required this.value,
    this.nameStyle,
    this.valueStyle,
    this.defaultValue = '',
    Key? key,
  }) : super(key: key);
  final String name;
  final String value;
  final TextStyle? nameStyle;
  final TextStyle? valueStyle;
  final String defaultValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: Text(
                  name,
                  style: nameStyle ??
                      Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(fontSize: 16),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Flexible(
                flex: 3,
                child: Text(
                  value,
                  style: valueStyle ?? Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10)
        ],
      ),
    );
  }
}
