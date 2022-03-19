// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//quest.InfoCollectViewPhone

package quest
{
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import flash.net.URLVariables;

    public class InfoCollectViewPhone extends InfoCollectView 
    {

        public function InfoCollectViewPhone()
        {
            Type = 2;
        }

        override protected function addLabel():void
        {
            _dataLabel = ComponentFactory.Instance.creat("core.quest.infoCollect.Label");
            _dataLabel.text = LanguageMgr.GetTranslation("ddt.quest.collectInfo.phone");
        }

        override protected function fillArgs(_arg_1:URLVariables):URLVariables
        {
            _arg_1["phone"] = _arg_1["input"];
            return (_arg_1);
        }

        override protected function updateHelper(_arg_1:String):String
        {
            return ("");
        }


    }
}//package quest

