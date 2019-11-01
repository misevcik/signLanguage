package sk.doreto.signlanguage.ui.common;

import sk.doreto.signlanguage.database.Word;

public interface IDictionaryFragment {
    void videoForward();
    void videoBackward();

    void updateContent(Word word);
}
