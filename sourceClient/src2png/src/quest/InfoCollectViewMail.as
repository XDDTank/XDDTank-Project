// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//quest.InfoCollectViewMail

package quest
{
    import flash.net.URLVariables;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import ddt.manager.SoundManager;
    import flash.events.MouseEvent;

    public class InfoCollectViewMail extends InfoCollectView 
    {

        private const DomainArray:Array = ["163.com", "qq.com"];

        public function InfoCollectViewMail()
        {
            Type = 1;
        }

        override protected function fillArgs(_arg_1:URLVariables):URLVariables
        {
            _arg_1["mail"] = _arg_1["input"];
            return (_arg_1);
        }

        override protected function modifyView():void
        {
            _inputData.maxChars = 50;
        }

        override protected function addLabel():void
        {
            _dataLabel = ComponentFactory.Instance.creat("core.quest.infoCollect.Label");
            _dataLabel.text = LanguageMgr.GetTranslation("ddt.quest.collectInfo.email");
        }

        override protected function updateHelper(_arg_1:String):String
        {
            if (_arg_1 == "")
            {
                return ("");
            };
            if (_arg_1.indexOf("@") < 0)
            {
                return ("ddt.quest.collectInfo.notValidMailAddress");
            };
            var _local_2:String = _arg_1.substr((_arg_1.indexOf("@") + 1));
            if (_local_2.indexOf(".") < 0)
            {
                return ("ddt.quest.collectInfo.notValidMailAddress");
            };
            return ("ddt.quest.collectInfo.validMailAddress");
        }

        private function cansearch(_arg_1:String):Boolean
        {
            var _local_2:String;
            for each (_local_2 in this.DomainArray)
            {
                if (_local_2 == _arg_1)
                {
                    return (true);
                };
            };
            return (false);
        }

        override protected function __onSendBtn(_arg_1:MouseEvent):void
        {
            SoundManager.instance.playButtonSound();
            if (_inputData.text.length < 1)
            {
                alert("ddt.quest.collectInfo.noMail");
                return;
            };
            sendData();
        }


    }
}//package quest

