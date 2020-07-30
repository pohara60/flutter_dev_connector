import 'package:flutter/material.dart';
import 'package:flutter_dev_connector/models/profile.dart';
import 'package:flutter_dev_connector/services/alert_service.dart';
import 'package:flutter_dev_connector/services/profile_service.dart';
import 'package:flutter_dev_connector/utils/date_format.dart';
import 'package:flutter_dev_connector/utils/logger.dart';
import 'package:flutter_dev_connector/widgets/checkbox_form_field.dart';
import 'package:flutter_dev_connector/widgets/text_form_field_date_picker.dart';
import 'package:provider/provider.dart';

class AddEducationView extends StatefulWidget {
  @override
  _AddEducationViewState createState() => _AddEducationViewState();
}

class _AddEducationViewState extends State<AddEducationView> {
  static final _log = getLogger('AddEducationViewState');

  final _form = GlobalKey<FormState>();
  final _schoolFocusNode = FocusNode();
  final _degreeFocusNode = FocusNode();
  final _fieldofstudyFocusNode = FocusNode();
  final _fromFocusNode = FocusNode();
  final _toFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  var _doneInit = false;
  Education education;

  @override
  void dispose() {
    super.dispose();
    _schoolFocusNode.dispose();
    _degreeFocusNode.dispose();
    _fieldofstudyFocusNode.dispose();
    _fromFocusNode.dispose();
    _toFocusNode.dispose();
    _descriptionFocusNode.dispose();
  }

  @override
  void didChangeDependencies() {
    if (!_doneInit) {
      education = Education();
      education.from = getToday();
      _doneInit = true;
    }
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) return;

    _form.currentState.save();
    try {
      await Provider.of<ProfileService>(context, listen: false)
          .addEducation(education);
      Provider.of<AlertService>(context, listen: false)
          .addAlert("Education added");
      Navigator.of(context).pop();
    } catch (error) {
      await showDialog<Null>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occurred!'),
          content: Text(error.toString()),
          actions: <Widget>[
            FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                })
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _log.v('build called v');

    final themeData = Theme.of(context);
    final dateFormat = getDateFormat();
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Education'),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm),
        ],
      ),
      body: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Add Your Education',
                    style: themeData.textTheme.headline5),
                Text('Add any school, bootcamp, etc that you have attended',
                    style: themeData.textTheme.headline6),
                TextFormField(
                  initialValue: education.school ?? "",
                  decoration: InputDecoration(
                    labelText: '* School or Bootcamp',
                    hintText: '',
                  ),
                  focusNode: _schoolFocusNode,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) =>
                      FocusScope.of(context).requestFocus(_degreeFocusNode),
                  validator: (value) =>
                      value == '' ? 'School is required!' : null,
                  onSaved: (value) => education.school = value.trim(),
                ),
                TextFormField(
                  initialValue: education.degree,
                  decoration: InputDecoration(
                    labelText: '* Degree or Certificate',
                    hintText: '',
                  ),
                  focusNode: _degreeFocusNode,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) => FocusScope.of(context)
                      .requestFocus(_fieldofstudyFocusNode),
                  validator: (value) =>
                      value == '' ? 'Degree is required!' : null,
                  onSaved: (value) => education.degree = value.trim(),
                ),
                TextFormField(
                  initialValue: education.fieldofstudy,
                  decoration: InputDecoration(
                    labelText: "Field Of Study",
                    hintText: "",
                  ),
                  focusNode: _fieldofstudyFocusNode,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) =>
                      FocusScope.of(context).requestFocus(_fromFocusNode),
                  validator: (value) => null,
                  onSaved: (value) => education.fieldofstudy = value.trim(),
                ),
                TextFormFieldDatePicker(
                  labelText: "From",
                  focusNode: _fromFocusNode,
                  nextFocusNode: _toFocusNode,
                  dateFormat: dateFormat,
                  initialDate: education.from ?? getToday(),
                  lastDate: getToday(),
                  firstDate: DateTime(1970),
                  onSaved: (date) => education.from = date,
                  validator: (date) {
                    if (date == null) return 'From date required!';
                    return null;
                  },
                ),
                CheckboxFormField(
                  context: context,
                  initialValue: education.current ?? false,
                  title: Text('Current'),
                  onSaved: (checked) => education.current = checked,
                  validator: (checked) => null,
                ),
                TextFormFieldDatePicker(
                  labelText: "To",
                  focusNode: _toFocusNode,
                  nextFocusNode: _descriptionFocusNode,
                  dateFormat: dateFormat,
                  initialDate: education.to ?? education.from ?? getToday(),
                  lastDate: getToday(),
                  firstDate: DateTime(1970),
                  onSaved: (date) => education.to = date,
                  validator: (date) {
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: education.description,
                  decoration: InputDecoration(
                    labelText: "Program Description",
                    hintText: "",
                  ),
                  focusNode: _descriptionFocusNode,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (value) => _saveForm(),
                  validator: (value) => null,
                  onSaved: (value) => education.description = value.trim(),
                ),
                RaisedButton(
                  child:
                      Text('Submit', style: themeData.accentTextTheme.button),
                  color: themeData.accentColor,
                  onPressed: () => _saveForm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
