package sk.doreto.signlanguage.ui.education;


import java.util.ArrayList;
import java.util.List;

public class QuestionItem {

    public static class AnswerItem {
        public String answerText;
        public boolean isCorrect;
    }

    public List<AnswerItem> answerCollection = new ArrayList<AnswerItem>();
    public String video;
    public int selectedAnswer = -1;
}
