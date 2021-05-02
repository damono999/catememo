import 'package:flutter/material.dart';

class Accordion extends StatefulWidget {
  final String headerText;
  final IconData icon;
  final Color iconColor;
  final String body;
  final Function fn;
  final Function removeFn;

  Accordion({
    this.headerText,
    this.icon,
    this.iconColor,
    this.body,
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
                    widget.headerText,
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
                subtitle: Text(widget.body),
                trailing: Icon(Icons.delete),
                onTap: () {},
              ),
            ),
            isExpanded: _isExpanded,
          )
        ],
      ),
    );
  }
}
