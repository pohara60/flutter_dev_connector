import 'package:flutter/material.dart';
import 'package:flutter_dev_connector/models/profile.dart';
import 'package:flutter_dev_connector/services/alert_service.dart';
import 'package:flutter_dev_connector/services/profile_service.dart';
import 'package:flutter_dev_connector/utils/date_format.dart';
import 'package:flutter_dev_connector/utils/logger.dart';
import 'package:flutter_dev_connector/widgets/checkbox_form_field.dart';
import 'package:flutter_dev_connector/widgets/text_form_field_date_picker.dart';
import 'package:provider/provider.dart';

class AddExperienceView extends StatefulWidget {
  @override
  _AddExperienceViewState createState() => _AddExperienceViewState();
}

class _AddExperienceViewState extends State<AddExperienceView> {
  static final _log = getLogger('AddExperienceViewState');

  final _form = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _companyFocusNode = FocusNode();
  final _locationFocusNode = FocusNode();
  final _fromFocusNode = FocusNode();
  final _toFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  var _doneInit = false;
  Experience experience;

  @override
  void dispose() {
    super.dispose();
    _titleFocusNode.dispose();
    _companyFocusNode.dispose();
    _locationFocusNode.dispose();
    _fromFocusNode.dispose();
    _toFocusNode.dispose();
    _descriptionFocusNode.dispose();
  }

  @override
  void didChangeDependencies() {
    if (!_doneInit) {
      experience = Experience();
      experience.from = getToday();
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
          .addExperience(experience);
      Provider.of<AlertService>(context, listen: false)
          .addAlert("Experience added");
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
        title: Text('Add Experience'),
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
                Text('Add an Experience', style: themeData.textTheme.headline5),
                Text(
                    'Add any developer/programming positions that you have had in the past',
                    style: themeData.textTheme.headline6),
                TextFormField(
                  initialValue: experience.title ?? "",
                  decoration: InputDecoration(
                    labelText: 'Job Title',
                    hintText: '',
                  ),
                  focusNode: _titleFocusNode,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) =>
                      FocusScope.of(context).requestFocus(_companyFocusNode),
                  validator: (value) =>
                      value == '' ? 'Title is required!' : null,
                  onSaved: (value) => experience.title = value.trim(),
                ),
                TextFormField(
                  initialValue: experience.company,
                  decoration: InputDecoration(
                    labelText: 'Company',
                    hintText: '',
                  ),
                  focusNode: _companyFocusNode,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) =>
                      FocusScope.of(context).requestFocus(_locationFocusNode),
                  validator: (value) =>
                      value == '' ? 'Company is required!' : null,
                  onSaved: (value) => experience.company = value.trim(),
                ),
                TextFormField(
                  initialValue: experience.location,
                  decoration: InputDecoration(
                    labelText: "Location",
                    hintText: "City & state suggested (eg. Boston, MA)",
                  ),
                  focusNode: _locationFocusNode,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) =>
                      FocusScope.of(context).requestFocus(_fromFocusNode),
                  validator: (value) => null,
                  onSaved: (value) => experience.location = value.trim(),
                ),
                TextFormFieldDatePicker(
                  labelText: "From",
                  focusNode: _fromFocusNode,
                  nextFocusNode: _toFocusNode,
                  dateFormat: dateFormat,
                  initialDate: experience.from ?? getToday(),
                  lastDate: getToday(),
                  firstDate: DateTime(1970),
                  onSaved: (date) => experience.from = date,
                  validator: (date) {
                    if (date == null) return 'From date required!';
                    return null;
                  },
                ),
                CheckboxFormField(
                  context: context,
                  initialValue: experience.current ?? false,
                  title: Text('Current'),
                  onSaved: (checked) => experience.current = checked,
                  validator: (checked) => null,
                ),
                TextFormFieldDatePicker(
                  labelText: "To",
                  focusNode: _toFocusNode,
                  nextFocusNode: _descriptionFocusNode,
                  dateFormat: dateFormat,
                  initialDate: experience.to ?? experience.from ?? getToday(),
                  lastDate: getToday(),
                  firstDate: DateTime(1970),
                  onSaved: (date) => experience.to = date,
                  validator: (date) {
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: experience.description,
                  decoration: InputDecoration(
                    labelText: "Job Description",
                    hintText: "",
                  ),
                  focusNode: _descriptionFocusNode,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (value) => _saveForm(),
                  validator: (value) => null,
                  onSaved: (value) => experience.description = value.trim(),
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
