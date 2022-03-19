// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//im.AddBlackFrame

package im
{
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.vo.AlertInfo;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import ddt.manager.MessageTipManager;

    public class AddBlackFrame extends AddFriendFrame implements Disposeable 
    {


        override protected function initContainer():void
        {
            _alertInfo = new AlertInfo();
            _alertInfo.title = LanguageMgr.GetTranslation("tank.view.im.AddBlackListFrame.titleText");
            _alertInfo.submitEnabled = false;
            info = _alertInfo;
            var _local_1:Scale9CornerImage = ComponentFactory.Instance.creatComponentByStylename("im.addFriendInputBG");
            addToContent(_local_1);
            _inputText = ComponentFactory.Instance.creat("textinput");
            _inputText.maxChars = MAX_CHAES;
            addToContent(_inputText);
            _explainText = ComponentFactory.Instance.creat("IM.TextStyle");
            _explainText.text = LanguageMgr.GetTranslation("tank.view.im.AddFriendFrame.name");
            addToContent(_explainText);
            _hintText = ComponentFactory.Instance.creat("IM.TextStyleII");
            _hintText.text = LanguageMgr.GetTranslation("tank.view.im.AddBlackListFrame.chat");
            addToContent(_hintText);
        }

        override protected function submit():void
        {
            if (((_name == "") || (_name == null)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("IMControl.addNullFriend"));
                return;
            };
            hide();
            IMController.Instance.addBlackList(_name);
        }

        override public function dispose():void
        {
            super.dispose();
        }


    }
}//package im

