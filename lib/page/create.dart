import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/models/model.dart';

enum FormMode { create, edit }

class CreateEditScreen extends StatefulWidget {
  const CreateEditScreen({super.key, required this.mode, this.blog});

  final FormMode mode;
  final Blog? blog;

  @override
  _CreateEditScreenState createState() => _CreateEditScreenState();
}

class _CreateEditScreenState extends State<CreateEditScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _slugController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _imageController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  initState() {
    super.initState();
    if (widget.mode == FormMode.edit) {
      _titleController.text = widget.blog!.title;
      _slugController.text = widget.blog!.slug;
      _categoryController.text = widget.blog!.category;
      _imageController.text = widget.blog!.image;
      _descriptionController.text = widget.blog!.description;
    }
  }

  getBlog() {
    return Blog(
        title: _titleController.text,
        slug: _slugController.text,
        category: _categoryController.text,
        image: _imageController.text,
        description: _descriptionController.text);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Data Post'),
        trailing: GestureDetector(
          onTap: () {
            if (_titleController.text.isEmpty ||
                _slugController.text.isEmpty ||
                _categoryController.text.isEmpty ||
                _imageController.text.isEmpty ||
                _descriptionController.text.isEmpty) {
              return;
            }
            Navigator.pop(context, getBlog());
          },
          child: Text(widget.mode == FormMode.create ? 'Tambah' : 'Edit'),
        ),
      ),
      child: SafeArea(
        child: CupertinoFormSection(
          header: Text(
              widget.mode == FormMode.create ? 'Masukkan Data' : 'Edit Data'),
          children: [
            CupertinoFormRow(
                prefix: Text('title'),
                child: CupertinoTextFormFieldRow(
                  controller: _titleController,
                  placeholder: 'Masukkan Title',
                )),
            CupertinoFormRow(
                prefix: Text('slug'),
                child: CupertinoTextFormFieldRow(
                  controller: _slugController,
                  placeholder: 'Masukkan Slug',
                )),
            CupertinoFormRow(
                prefix: Text('category'),
                child: CupertinoTextFormFieldRow(
                  controller: _categoryController,
                  placeholder: 'Masukkan Category',
                )),
            CupertinoFormRow(
                prefix: Text('image'),
                child: CupertinoTextFormFieldRow(
                  controller: _imageController,
                  placeholder: 'Masukkan Image',
                )),
            CupertinoFormRow(
                prefix: Text('description'),
                child: CupertinoTextFormFieldRow(
                  controller: _descriptionController,
                  placeholder: 'Masukkan Description',
                )),
          ],
        ),
      ),
    );
  }
}
