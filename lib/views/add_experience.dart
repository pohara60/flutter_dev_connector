import 'package:flutter/material.dart';
import 'package:flutter_dev_connector/models/profile.dart';
import 'package:flutter_dev_connector/services/profile_service.dart';
import 'package:flutter_dev_connector/utils/date_format.dart';
import 'package:flutter_dev_connector/utils/logger.dart';
import 'package:flutter_dev_connector/widgets/text_form_field_date_picker.dart';
import 'package:provider/provider.dart';

class AddExperienceView extends StatefulWidget {
  static const routeName = "/add-experience";

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
  final _fromController = TextEditingController();

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
      experience = await Provider.of<ProfileService>(context, listen: false)
          .addExperience(experience);
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
    _fromController.text = dateFormat.format(experience.from);
    _log.v('build - _fromController.text=${_fromController.text}');
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
                  validator: (value) => null,
                  onSaved: (value) => experience.title = value,
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
                  validator: (value) => null,
                  onSaved: (value) => experience.company = value,
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
                  onSaved: (value) => experience.location = value,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _fromController,
                        //initialValue: dateFormat.format(experience.from),
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          labelText: "From",
                          hintText: "",
                        ),
                        focusNode: _fromFocusNode,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) =>
                            FocusScope.of(context).requestFocus(_toFocusNode),
                        validator: (value) {
                          try {
                            final date = dateFormat.parseLoose(value);
                            return null;
                          } catch (err) {
                            return 'Invalid date!';
                          }
                        },
                        onSaved: (value) =>
                            experience.from = dateFormat.parseLoose(value),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () async {
                        try {
                          experience.from =
                              dateFormat.parseLoose(_fromController.text);
                        } catch (err) {}
                        final date =
                            await _selectDate(context, experience.from);
                        if (date != null) {
                          setState(() {
                            experience.from = date;
                          });
                        }
                      },
                    ),
                  ],
                ),
                TextFormFieldDatePicker(
                  labelText: "To",
                  focusNode: _toFocusNode,
                  dateFormat: dateFormat,
                  initialDate: experience.to ?? getToday(),
                  lastDate: getToday(),
                  firstDate: DateTime(1970),
                  onSaved: (date) => experience.to = date,
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
                  onSaved: (value) => experience.description = value,
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

Future<DateTime> _selectDate(BuildContext context, DateTime initial) async {
  final DateTime d = await showDatePicker(
    //we wait for the dialog to return
    context: context,
    initialDate: initial ?? getToday(),
    firstDate: DateTime(1970),
    lastDate: getToday(),
  );
  return d;
}
