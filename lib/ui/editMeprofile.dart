import 'dart:async';

import 'package:card_settings/helpers/converter_functions.dart';
import 'package:card_settings/widgets/action_fields/card_settings_button.dart';
import 'package:card_settings/widgets/card_settings_panel.dart';
import 'package:card_settings/widgets/information_fields/card_settings_header.dart';
import 'package:card_settings/widgets/numeric_fields/card_settings_slider.dart';
import 'package:card_settings/widgets/picker_fields/card_settings_checkbox_picker.dart';
import 'package:card_settings/widgets/picker_fields/card_settings_date_picker.dart';
import 'package:card_settings/widgets/picker_fields/card_settings_file_picker.dart';
import 'package:card_settings/widgets/picker_fields/card_settings_number_picker.dart';
import 'package:card_settings/widgets/picker_fields/card_settings_radio_picker.dart';
import 'package:card_settings/widgets/text_fields/card_settings_paragraph.dart';
import 'package:card_settings/widgets/text_fields/card_settings_phone.dart';
import 'package:card_settings/widgets/text_fields/card_settings_text.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:honeybee/model/model.dart';
import 'package:honeybee/model/results.dart';
import 'package:intl/intl.dart';

typedef LabelledValueChanged<T, U> = void Function(T label, U value);

class EditProfile extends StatefulWidget {
  EditProfile({Key key, @required this.touserid})
      : super(key: key);

  final String touserid;

  EditProfileState createState() => EditProfileState( touserid: touserid);

}

class EditProfileState extends State<EditProfile> {

  EditProfileState({Key key, @required this.touserid});

  final String touserid;

  PonyModel _ponyModel;
  bool loaded = false;

  @override
  void initState() {
    super.initState();

    initModel();
  }

  void initModel() async {
    _ponyModel = PonyModel();
    await _ponyModel.loadMedia();
    setState(() => loaded = true);
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _autoValidate = false;

  final GlobalKey<FormState> _nameKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _ageKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _genderKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _descriptionlKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _hobbiesKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _photoKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _datetimeKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _phoneKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _sliderKey = GlobalKey<FormState>();

  final FocusNode _nameNode = FocusNode();
  final FocusNode _descriptionNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    if (loaded) {
      return Form(
        key: _formKey,
        child: _buildPortraitLayout()
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  Future savePressed() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      showResults(context, _ponyModel);
    } else {
      showErrors(context);
      setState(() => _autoValidate = true);
    }
  }

  void resetPressed() {
    setState(() => loaded = false);
    initModel();
    _formKey.currentState.reset();
  }

  CardSettings _buildPortraitLayout() {
    return CardSettings.sectioned(
      labelWidth: 150,
      contentAlign: TextAlign.right,
      children: <CardSettingsSection>[
        CardSettingsSection(
          header: CardSettingsHeader(
            label: 'Bio',
          ),
          children: <Widget>[
            _buildCardSettingsText_Name(),
            _buildCardSettingsRadioPicker_Gender(),
            _buildCardSettingsNumberPicker_Age(),
            _buildCardSettingsParagraph_Description(5),
            _buildCardSettingsCheckboxPicker_Hobbies(),
            _buildCardSettingsDateTimePicker_Birthday(),
          ],
        ),
        CardSettingsSection(
          header: CardSettingsHeader(
            label: 'First Show',
          ),
          children: <Widget>[
            _buildCardSettingsPhotoPicker(),
            _buildCardSettingsPhone(),
          ],
        ),
        CardSettingsSection(
          header: CardSettingsHeader(
            label: 'Actions',
          ),
          children: <Widget>[
            _buildCardSettingsButton_Save(),
            _buildCardSettingsButton_Reset(),
          ],
        ),
      ],
    );
  }

  CardSettings _buildLandscapeLayout() {

  }

  CardSettingsButton _buildCardSettingsButton_Reset() {
    return CardSettingsButton(
      label: 'RESET',
      isDestructive: true,
      onPressed: resetPressed,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  CardSettingsButton _buildCardSettingsButton_Save() {
    return CardSettingsButton(
      label: 'SAVE',
      backgroundColor: Colors.green,
      onPressed: savePressed,
    );
  }

  CardSettingsPhone _buildCardSettingsPhone() {
    return CardSettingsPhone(
      key: _phoneKey,
      label: 'Box Office',
      initialValue: _ponyModel.boxOfficePhone,
      autovalidate: _autoValidate,
      validator: (value) {
        return null;
      },
      onSaved: (value) => _ponyModel.boxOfficePhone = value,
      onChanged: (value) {
        setState(() {
          _ponyModel.boxOfficePhone = value;
        });

      },
    );
  }

  CardSettingsFilePicker _buildCardSettingsPhotoPicker() {
    return CardSettingsFilePicker(
      key: _photoKey,
      icon: Icon(Icons.photo),
      label: 'Photo',
      fileType: FileTypeCross.image,
      initialValue: _ponyModel.photo,
      onSaved: (value) => _ponyModel.photo = value,
      onChanged: (value) {
        setState(() {
          _ponyModel.photo = value;
        });
      },
    );
  }

  CardSettingsSlider _cardSettingsSlider(){
    return CardSettingsSlider(
      key: _sliderKey,
      icon: Icon(Icons.slideshow),
      label: "Slider",

    );
  }

  CardSettingsDatePicker _buildCardSettingsDateTimePicker_Birthday() {
    return CardSettingsDatePicker(
      key: _datetimeKey,
      icon: Icon(Icons.card_giftcard, color: Colors.yellow[700]),
      label: 'Birth day',
      dateFormat: DateFormat.yMMMMd(),
      initialValue: _ponyModel.showDateTime,
      onSaved: (value) => _ponyModel.showDateTime =
          updateJustDate(value, _ponyModel.showDateTime),
      onChanged: (value) {
        setState(() {
          _ponyModel.showDateTime = value;
        });

      },
    );
  }

  CardSettingsCheckboxPicker _buildCardSettingsCheckboxPicker_Hobbies() {
    return CardSettingsCheckboxPicker(
      key: _hobbiesKey,
      label: 'Hobbies',
      initialValues: _ponyModel.hobbies,
      options: allHobbies,
      autovalidate: _autoValidate,
      validator: (List<String> value) {
        if (value == null || value.isEmpty)
          return 'You must pick at least one hobby.';

        return null;
      },
      onSaved: (value) => _ponyModel.hobbies = value,
      onChanged: (value) {
        setState(() {
          _ponyModel.hobbies = value;
        });

      },
    );
  }

  CardSettingsParagraph _buildCardSettingsParagraph_Description(int lines) {
    return CardSettingsParagraph(
      key: _descriptionlKey,
      label: 'Description',
      initialValue: _ponyModel.description,
      numberOfLines: lines,
      focusNode: _descriptionNode,
      onSaved: (value) => _ponyModel.description = value,
      onChanged: (value) {
        setState(() {
          _ponyModel.description = value;
        });

      },
    );
  }

  CardSettingsNumberPicker _buildCardSettingsNumberPicker_Age(
      {TextAlign labelAlign}) {
    return CardSettingsNumberPicker(
      key: _ageKey,
      label: 'Age',
      labelAlign: labelAlign,
      initialValue: _ponyModel.age,
      min: 1,
      max: 17,
      stepInterval: 2,
      validator: (value) {
        if (value == null) return 'Age is required.';
        if (value > 20) return 'No grown-ups allwed!';
        if (value < 3) return 'No Toddlers allowed!';
        return null;
      },
      onSaved: (value) => _ponyModel.age = value,
      onChanged: (value) {
        setState(() {
          _ponyModel.age = value;
        });

      },
    );
  }

  CardSettingsText _buildCardSettingsText_Name() {
    return CardSettingsText(
      key: _nameKey,
      label: 'Name',
      hintText: 'something cute...',
      initialValue: _ponyModel.name,
      requiredIndicator: Text('*', style: TextStyle(color: Colors.red)),
      autovalidate: _autoValidate,
      focusNode: _nameNode,
      inputAction: TextInputAction.next,
      inputActionNode: _descriptionNode,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Name is required.';
        return null;
      },
      onSaved: (value) => _ponyModel.name = value,
      onChanged: (value) {
        setState(() {
          _ponyModel.name = value;
        });

      },
    );
  }

  CardSettingsRadioPicker _buildCardSettingsRadioPicker_Gender() {
    return CardSettingsRadioPicker(
      key: _genderKey,
      label: 'Gender',
      initialValue: _ponyModel.gender,
      hintText: 'Select One',
      autovalidate: _autoValidate,
      options: <String>['Male', 'Female'],
      validator: (String value) {
        if (value == null || value.isEmpty) return 'You must pick a gender.';
        return null;
      },
      onSaved: (value) => _ponyModel.gender = value,
      onChanged: (value) {
        setState(() {
          _ponyModel.gender = value;
        });

      },
    );
  }
}
