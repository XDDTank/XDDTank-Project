// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.view.selfConsortia.EventListItem

package consortion.view.selfConsortia
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import ddt.manager.LanguageMgr;
    import ddt.data.ConsortiaEventInfo;
    import com.pickgliss.utils.ObjectUtils;

    public class EventListItem extends Sprite implements Disposeable 
    {

        private var _backGroud:ScaleFrameImage;
        private var _eventType:ScaleFrameImage;
        private var _content:FilterFrameText;
        private var _tiemTxt:FilterFrameText;

        public function EventListItem()
        {
            this.initView();
        }

        private function initView():void
        {
            this._backGroud = ComponentFactory.Instance.creatComponentByStylename("eventItem.BG");
            this._eventType = ComponentFactory.Instance.creatComponentByStylename("eventItem.type");
            this._content = ComponentFactory.Instance.creatComponentByStylename("eventItem.content");
            this._tiemTxt = ComponentFactory.Instance.creatComponentByStylename("eventItem.time");
            PositionUtils.setPos(this._tiemTxt, "asset.ddtconsortion.eventTimeTxt");
            addChild(this._backGroud);
            addChild(this._content);
            addChild(this._tiemTxt);
        }

        public function updateBaceGroud(_arg_1:int):void
        {
            if ((_arg_1 % 2) != 0)
            {
                this._backGroud.setFrame(2);
            }
            else
            {
                this._backGroud.setFrame(1);
            };
        }

        public function set info(_arg_1:ConsortiaEventInfo):void
        {
            if (_arg_1 == null)
            {
                return;
            };
            var _local_2:String = _arg_1.Date.toString().split(" ")[0];
            switch (_arg_1.Type)
            {
                case 5:
                    this._eventType.setFrame(1);
                    if (_arg_1.NickName.toLowerCase() == "gm")
                    {
                        this._content.htmlText = LanguageMgr.GetTranslation("ddt.consortia.event.contributeGM", _arg_1.EventValue);
                        this._tiemTxt.text = _local_2;
                    }
                    else
                    {
                        this._content.htmlText = LanguageMgr.GetTranslation("ddt.consortia.event.contribute", _arg_1.NickName, _arg_1.EventValue);
                        this._tiemTxt.text = _local_2;
                    };
                    return;
                case 6:
                    this._content.htmlText = LanguageMgr.GetTranslation("ddt.consortia.event.join", _arg_1.ManagerName, _arg_1.NickName);
                    this._tiemTxt.text = _local_2;
                    return;
                case 7:
                    this._content.htmlText = LanguageMgr.GetTranslation("ddt.consortia.event.quite", _arg_1.ManagerName, _arg_1.NickName);
                    this._tiemTxt.text = _local_2;
                    return;
                case 8:
                    this._content.htmlText = LanguageMgr.GetTranslation("ddt.consortia.event.quit", _arg_1.NickName);
                    this._tiemTxt.text = _local_2;
                    return;
                case 9:
                    this._content.htmlText = _arg_1.ManagerName;
                    this._tiemTxt.text = _local_2;
                    return;
            };
        }

        override public function get height():Number
        {
            return (this._backGroud.height);
        }

        public function dispose():void
        {
            ObjectUtils.disposeAllChildren(this);
            this._backGroud = null;
            this._eventType = null;
            this._content = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package consortion.view.selfConsortia

