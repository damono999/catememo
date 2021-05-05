import 'package:catememo/enums/color_enum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';

class Accordion extends StatefulWidget {
  final String title;
  final int colorId;
  final String memo;
  final Timestamp createdAt;
  final Function editFn;
  final Function removeFn;

  Accordion({
    this.title,
    this.colorId,
    this.memo,
    this.createdAt,
    this.editFn,
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
                  backgroundColor:
                      ColorEnumList.getTargetCategory(widget.colorId).color,
                  maxRadius: 16,
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
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 8),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: MarkdownBody(
                      data: widget.memo,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          DateFormat('yyyy-MM-dd')
                              .format(widget.createdAt.toDate())
                              .toString(),
                        ),
                      ),
                      InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.edit,
                            color: Colors.grey,
                            size: 32,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(30),
                        splashColor: Colors.lightGreen,
                        onTap: widget.editFn,
                      ),
                      SizedBox(
                        width: 24,
                      ),
                      InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.delete,
                            color: Colors.grey,
                            size: 32,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(30),
                        splashColor: Colors.red,
                        onTap: widget.removeFn,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            isExpanded: _isExpanded,
          )
        ],
      ),
    );
  }
}
