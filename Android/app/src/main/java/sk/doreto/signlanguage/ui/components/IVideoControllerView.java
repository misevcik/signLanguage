package sk.doreto.signlanguage.ui.components;

public interface IVideoControllerView {

    void videoPlay();
    void videoForward();
    void videoBackward();
    void videoRotate(boolean videoRotate);
    void videoSpeed(boolean videoSlowSpeed);
}
