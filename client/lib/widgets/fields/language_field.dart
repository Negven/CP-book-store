

import 'package:client/enum/language_code.dart';
import 'package:client/service/translations_service.dart';
import 'package:client/utils/convert_utils.dart';
import 'package:client/utils/validate_utils.dart';
import 'package:client/widgets/modal.dart';
import 'package:client/widgets/universal/universal_field.dart';
import 'package:client/widgets/universal/universal_item.dart';
import 'package:flutter/material.dart';

class UniversalLanguageCode extends UniversalItem<LanguageCode> {

  UniversalLanguageCode(super.value);

  static UniversalLanguageCode? fromCode(LanguageCode? languageCode) {
    if (languageCode == null) return null;
    return UniversalLanguageCode(languageCode);
  }

  static List<UniversalLanguageCode> get languages {

    final en = LanguageCode.en.name;
    final nb = LanguageCode.nb.name;

    Json ens = {
      en: "English",
      nb: "Norwegian",
    };

    Json nbs = {
      en: "Engelsk",
      nb: "Norsk"
    };

    Json languages = {
      en: ens,
      nb: nbs,
    };

    Json locals = {};
    for (var lang in LanguageCode.values) {
      locals[lang.name] = languages[lang.name][lang.name];
    }
    languages[LanguageCode.local] = locals;

    return UniversalItem.toLocalized(languages, (_) => LanguageCode.values, UniversalLanguageCode.new, hideInLocal: false);
  }
}


class LanguageField extends StatelessWidget {

  final UniversalController<UniversalLanguageCode> language;

  LanguageField(this.language, {super.key}) {
    language.loaded(UniversalLanguageCode.languages.selectBasedOn(language.value));
  }

  Modal toModal(UniversalField<UniversalLanguageCode> field) {

    final controller = UniversalSelectableListController(values: UniversalLanguageCode.languages, selected: field.selected);

    final list = UniversalSelectableList<UniversalLanguageCode>(controller: controller, toTile: (item, onTap) {
      return UniversalSelectableTile(leading: UniversalSelectableList.toRadio(item.selected), title: item.title, subtitle: item.subtitle, selected: item.focused, onTap: onTap);
    });

    return Modal(title: field.title, body: ModalBody(children: [list]), footer: const UniversalFieldModalFooter());
  }

  @override
  Widget build(BuildContext context) {
    return UniversalField<UniversalLanguageCode>(
        title: 'languageField_title'.T,
        placeholder: 'languageField_placeholder'.T,
        controller: language,
        toModal: toModal,
        validator: ValidateUtils.requiredUniversal
    );
  }

}


