import 'package:flutter/material.dart';
import 'package:flutter_dev_connector/models/profile.dart';
import 'package:flutter_dev_connector/models/user.dart';
import 'package:flutter_dev_connector/services/auth_service.dart';
import 'package:flutter_dev_connector/services/profile_service.dart';
import 'package:flutter_dev_connector/utils/logger.dart';
import 'package:provider/provider.dart';

class CreateProfileView extends StatefulWidget {
  static const routeName = "/create-profile";

  final bool _isUpdate;
  CreateProfileView([this._isUpdate = false]);

  @override
  _CreateProfileViewState createState() => _CreateProfileViewState();
}

class _CreateProfileViewState extends State<CreateProfileView> {
  static final _log = getLogger('CreateProfileViewState');

  final _form = GlobalKey<FormState>();
  final _companyFocusNode = FocusNode();
  //final _companyUrlController = TextEditingController();

  var _isLoading = false;
  var _doneInit = false;
  Profile _profile;

  @override
  void dispose() {
    super.dispose();
    _companyFocusNode.dispose();
  }

  @override
  void didChangeDependencies() async {
    if (!_doneInit) {
      if (widget._isUpdate) {
        _profile = await Provider.of<ProfileService>(context, listen: false)
            .getCurrentProfile();
      } else {
        _profile = Profile();
        // Profile(
        //   id: '',
        //   user: User(
        //     id: '',
        //     name: '',
        //     email: '',
        //     password: '',
        //     avatar: '',
        //     date: DateTime.now(),
        //   ),
        //   company: '',
        //   website: '',
        //   location: '',
        //   status: '',
        //   skills: [],
        //   bio: '',
        //   githubusername: '',
        //   experience: [],
        //   education: [],
        //   social: Social(
        //     youtube: '',
        //     twitter: '',
        //     facebook: '',
        //     linkedin: '',
        //     instagram: '',
        //   ),
        //   date: DateTime.now(),
        // );

      }
      // _initValues = {
      //   'title': _profile.title,
      //   'description': _profile.description,
      //   'price': _profile.price.toString(),
      //   'imageURL': _profile.imageUrl,
      // };
      // _imageUrlController.text = _profile.imageUrl;
      _doneInit = true;
    }
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) return;

    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_profile.id != null) {
        await Provider.of<ProfileService>(context, listen: false)
            .updateProfile(_profile.id, _profile);
      } else {
        await Provider.of<ProfileService>(context, listen: false)
            .addProfile(_profile);
      }
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
    setState(() {
      _isLoading = false;
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    _log.v('build called v');

    final themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget._isUpdate ? 'Edit' : 'Create'} Profile'),
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
                Text('${widget._isUpdate ? 'Edit' : 'Create'} Your Profile',
                    style: themeData.textTheme.headline5),
                Text(
                    'Let\'s get some information to make your profile stand out',
                    style: themeData.textTheme.headline6),
                TextFormField(
                  initialValue: _profile.status,
                  decoration: InputDecoration(
                    labelText: 'Select Professional Status',
                    hintText:
                        'Give us an idea of where you are at in your career',
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) =>
                      FocusScope.of(context).requestFocus(_companyFocusNode),
                  validator: (value) {
                    if (value.isEmpty) return 'Select Professional Status';
                    return null;
                  },
                  onSaved: (value) {
                    _profile.status = value;
                  },
                ),
                TextFormField(
                  initialValue: _profile.company,
                  decoration: InputDecoration(
                    labelText: 'Company',
                    hintText: 'Could be your own company or one you work for',
                  ),
                  focusNode: _companyFocusNode,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) => _saveForm(),
                  validator: (value) {
                    //if (value.isEmpty) return 'Specify Company';
                    return null;
                  },
                  onSaved: (value) {
                    _profile.company = value;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
