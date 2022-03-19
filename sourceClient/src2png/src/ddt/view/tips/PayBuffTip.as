// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.tips.PayBuffTip

package ddt.view.tips
{
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.Event;
    import ddt.data.BuffInfo;

    public class PayBuffTip extends BuffTip 
    {

        private var _buffContainer:VBox;
        private var _describe:String;

        public function PayBuffTip()
        {
            this._buffContainer = ComponentFactory.Instance.creatComponentByStylename("asset.core.PayBuffTipContainer");
            addChild(this._buffContainer);
            _activeSp.visible = false;
            addEventListener(Event.REMOVED_FROM_STAGE, this.__leaveStage);
        }

        private function __leaveStage(_arg_1:Event):void
        {
            this._buffContainer.disposeAllChildren();
        }

        override protected function drawNameField():void
        {
            name_txt = ComponentFactory.Instance.creat("core.PayBuffTipNameTxt");
            addChild(name_txt);
        }

        override protected function setShow(_arg_1:Boolean, _arg_2:Boolean, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:String):void
        {
            var _local_7:*;
            _active = _arg_1;
            this._describe = _arg_6;
            this._buffContainer.disposeAllChildren();
            if (_active)
            {
                for each (_local_7 in _tempData.linkBuffs)
                {
                    if ((_local_7 is BuffInfo))
                    {
                        if (((!(_local_7.Type == 70)) && (_local_7.valided)))
                        {
                            this._buffContainer.addChild(new PayBuffListItem(_local_7));
                        };
                    }
                    else
                    {
                        this._buffContainer.addChild(new PayBuffListItem(_local_7));
                    };
                };
            };
            this.updateTxt();
            this.updateWH();
        }

        private function updateTxt():void
        {
            if (_active)
            {
                name_txt.text = _tempData.name;
                setChildIndex(name_txt, (numChildren - 1));
                describe_txt.visible = false;
                name_txt.visible = true;
            }
            else
            {
                name_txt.text = _tempData.name;
                setChildIndex(name_txt, (numChildren - 1));
                describe_txt.text = this._describe;
                describe_txt.x = name_txt.x;
                describe_txt.y = ((name_txt.y + name_txt.textHeight) + 4);
            };
        }

        override protected function updateWH():void
        {
            if (_active)
            {
                _bg.width = ((this._buffContainer.x + this._buffContainer.width) + this._buffContainer.x);
                _bg.height = ((this._buffContainer.y + this._buffContainer.height) + 16);
            }
            else
            {
                _bg.width = int((describe_txt.x + describe_txt.width));
                _bg.height = int(((describe_txt.y + describe_txt.height) + 10));
            };
            _width = _bg.width;
            _height = _bg.height;
        }


    }
}//package ddt.view.tips

