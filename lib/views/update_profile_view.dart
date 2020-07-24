import 'package:flutter/material.dart';
import 'package:flutter_dev_connector/models/profile.dart';
import 'package:flutter_dev_connector/services/alert_service.dart';
import 'package:flutter_dev_connector/services/auth_service.dart';
import 'package:flutter_dev_connector/services/profile_service.dart';
import 'package:flutter_dev_connector/utils/logger.dart';
import 'package:flutter_dev_connector/widgets/alert_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class UpdateProfileView extends StatefulWidget {
  static const createRouteName = "/create-profile";
  static const editRouteName = "/edit-profile";

  final bool _isUpdate;
  UpdateProfileView([this._isUpdate = false]);

  @override
  _UpdateProfileViewState createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<UpdateProfileView> {
  static final _log = getLogger('UpdateProfileViewState');

  final _form = GlobalKey<FormState>();
  final _companyFocusNode = FocusNode();
  final _websiteFocusNode = FocusNode();
  final _locationFocusNode = FocusNode();
  final _skillsFocusNode = FocusNode();
  final _githubFocusNode = FocusNode();
  final _bioFocusNode = FocusNode();
  //final _companyUrlController = TextEditingController();

  var _doneInit = false;
  Profile _profile;
  var _displaySocial = false;

  @override
  void dispose() {
    super.dispose();
    _companyFocusNode.dispose();
    _websiteFocusNode.dispose();
    _locationFocusNode.dispose();
    _skillsFocusNode.dispose();
    _githubFocusNode.dispose();
    _bioFocusNode.dispose();
  }

  @override
  void didChangeDependencies() {
    if (!_doneInit) {
      _log.v('init _isUpdate=${widget._isUpdate}');
      if (widget._isUpdate) {
        _profile = Provider.of<ProfileService>(context, listen: false).profile;
      } else {
        _profile = Profile();
        final _user = Provider.of<AuthService>(context, listen: false).user;
        _profile.user = _user;
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
    _log.v('_profile=$_profile');
    _log.v('_profile.status=${_profile?.status}');
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) return;

    _form.currentState.save();
    try {
      _profile = await Provider.of<ProfileService>(context, listen: false)
          .updateProfile(_profile);
      Provider.of<AlertService>(context, listen: false).addAlert(
        "Profile " + (widget._isUpdate ? "updated" : "created"),
      );
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
    _log.v('build _profile=$_profile');
    _log.v('build _profile.status=${_profile?.status}');

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
                AlertWidget(),
                Text('${widget._isUpdate ? 'Edit' : 'Create'} Your Profile',
                    style: themeData.textTheme.headline5),
                Text(
                    'Let\'s get some information to make your profile stand out',
                    style: themeData.textTheme.headline6),
                DropdownButtonFormField(
                  items: Profile.statusOptions.map((String status) {
                    return new DropdownMenuItem(
                        value: status, child: Text(status));
                  }).toList(),
                  value: _profile.status,
                  validator: (value) =>
                      value == null || value == '' ? 'Select an option!' : null,
                  onChanged: (newValue) {
                    // do other stuff with _category
                    setState(() => _profile.status = newValue);
                  },
                  decoration: InputDecoration(
                    labelText: '* Select Professional Status',
                    hintText:
                        'Give us an idea of where you are at in your career',
                  ),
                ),
                TextFormField(
                  initialValue: _profile.company,
                  decoration: InputDecoration(
                    labelText: 'Company',
                    hintText: 'Could be your own company or one you work for',
                  ),
                  focusNode: _companyFocusNode,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) =>
                      FocusScope.of(context).requestFocus(_websiteFocusNode),
                  validator: (value) => null,
                  onSaved: (value) => _profile.company = value.trim(),
                ),
                TextFormField(
                  initialValue: _profile.website,
                  decoration: InputDecoration(
                    labelText: "Website",
                    hintText: "Could be your own or a company website",
                  ),
                  focusNode: _websiteFocusNode,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) =>
                      FocusScope.of(context).requestFocus(_locationFocusNode),
                  validator: (value) => null,
                  onSaved: (value) => _profile.website = value.trim(),
                ),
                TextFormField(
                  initialValue: _profile.location,
                  decoration: InputDecoration(
                    labelText: "Location",
                    hintText: "City & state suggested (eg. Boston, MA)",
                  ),
                  focusNode: _locationFocusNode,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) =>
                      FocusScope.of(context).requestFocus(_skillsFocusNode),
                  validator: (value) => null,
                  onSaved: (value) => _profile.location = value.trim(),
                ),
                TextFormField(
                  initialValue: _profile.skills?.join(','),
                  decoration: InputDecoration(
                    labelText: "Skills",
                    hintText:
                        "Please use comma separated values (eg. HTML,CSS,JavaScript,PHP)",
                  ),
                  focusNode: _skillsFocusNode,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) =>
                      FocusScope.of(context).requestFocus(_githubFocusNode),
                  validator: (value) =>
                      value == '' ? 'Please enter skills!' : null,
                  onSaved: (value) => _profile.skills = value.trim().split(','),
                ),
                TextFormField(
                  initialValue: _profile.githubusername,
                  decoration: InputDecoration(
                    labelText: "Github Username",
                    hintText:
                        "If you want your latest repos and a Github link, include your username",
                  ),
                  focusNode: _githubFocusNode,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) =>
                      FocusScope.of(context).requestFocus(_bioFocusNode),
                  validator: (value) => null,
                  onSaved: (value) => _profile.githubusername = value.trim(),
                ),
                TextFormField(
                  initialValue: _profile.bio,
                  decoration: InputDecoration(
                    labelText: "A short bio of yourself",
                    hintText: "Tell us a little about yourself",
                  ),
                  focusNode: _bioFocusNode,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (value) => _saveForm(),
                  validator: (value) => null,
                  onSaved: (value) => _profile.bio = value.trim(),
                ),
                FlatButton(
                  child: Text('Add Social Network Links'),
                  onPressed: () => setState(() {
                    _displaySocial = !_displaySocial;
                  }),
                ),
                if (_displaySocial) SocialLinksWidget(_profile),
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

class SocialLinksWidget extends StatelessWidget {
  final Profile _profile;

  SocialLinksWidget(this._profile) {
    if (_profile.social == null) _profile.social = Social();
  }

  @override
  Widget build(BuildContext context) {
    final social = _profile.social;
    final themeData = Theme.of(context);
    final iconColor = themeData.accentColor;
    return Column(
      children: [
        SocialLinkWidget(
          icon: FontAwesomeIcons.twitter,
          iconColor: iconColor,
          label: "Twitter URL",
          getInitial: () => social.twitter,
          onSaved: (value) => social.twitter = value,
        ),
        SocialLinkWidget(
          icon: FontAwesomeIcons.facebook,
          iconColor: iconColor,
          label: "Facebook URL",
          getInitial: () => social.facebook,
          onSaved: (value) => social.facebook = value,
        ),
        SocialLinkWidget(
          icon: FontAwesomeIcons.youtube,
          iconColor: iconColor,
          label: "YouTube URL",
          getInitial: () => social.youtube,
          onSaved: (value) => social.youtube = value,
        ),
        SocialLinkWidget(
          icon: FontAwesomeIcons.linkedin,
          iconColor: iconColor,
          label: "Linkedin URL",
          getInitial: () => social.linkedin,
          onSaved: (value) => social.linkedin = value,
        ),
        SocialLinkWidget(
          icon: FontAwesomeIcons.instagram,
          iconColor: iconColor,
          label: "Instagram URL",
          getInitial: () => social.instagram,
          onSaved: (value) => social.instagram = value,
        ),
      ],
    );
  }
}

class SocialLinkWidget extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String Function() getInitial;
  final void Function(String) onSaved;

  const SocialLinkWidget(
      {this.icon, this.iconColor, this.label, this.getInitial, this.onSaved});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 30, child: FaIcon(icon, color: iconColor, size: 30)),
        SizedBox(width: 20),
        Expanded(
          child: TextFormField(
            initialValue: getInitial(),
            decoration: InputDecoration(
              //labelText: "Github Username",
              hintText: label,
            ),
            //focusNode: _githubFocusNode,
            //textInputAction: TextInputAction.next,
            //onFieldSubmitted: (value) =>
            //    FocusScope.of(context).requestFocus(_bioFocusNode),
            validator: (value) {
              if (value != '' && !Uri.parse(value).isAbsolute) {
                return 'Invalid URL';
              }
              return null;
            },
            onSaved: onSaved,
          ),
        ),
      ],
    );
  }
}
