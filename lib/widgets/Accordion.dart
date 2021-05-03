import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class Accordion extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final String memo;
  final Function fn;
  final Function removeFn;

  Accordion({
    this.title,
    this.icon,
    this.iconColor,
    this.memo,
    this.fn,
    this.removeFn,
  });

  @override
  _AccordionState createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: _buildPanel(),
      ),
    );
  }

  Widget _buildPanel() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _isExpanded = !isExpanded;
          });
        },
        children: [
          ExpansionPanel(
            canTapOnHeader: true,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                leading: CircleAvatar(
                  child: Icon(
                    widget.icon,
                    color: widget.iconColor,
                  ),
                ),
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            },
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                subtitle: MarkdownBody(
                  data: widget.memo,
                ),
                trailing: Icon(Icons.delete),
                onTap: widget.removeFn,
              ),
            ),
            isExpanded: _isExpanded,
          )
        ],
      ),
    );
  }
}
