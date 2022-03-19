// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.view.RoomPlayerItemIip

package room.view
{
    import com.pickgliss.ui.tip.BaseTip;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.tip.ITip;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.text.TextFormat;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.data.player.PlayerInfo;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class RoomPlayerItemIip extends BaseTip implements Disposeable, ITip 
    {

        public static const MAX_HEIGHT:int = 70;
        public static const MIN_HEIGHT:int = 22;

        private var _textFrameArray:Vector.<FilterFrameText>;
        private var _contentLabel:TextFormat;
        private var _bg:ScaleBitmapImage;

        public function RoomPlayerItemIip()
        {
            this.initView();
        }

        protected function initView():void
        {
            var _local_1:FilterFrameText;
            var _local_2:FilterFrameText;
            var _local_4:FilterFrameText;
            var _local_5:FilterFrameText;
            this._bg = ComponentFactory.Instance.creatComponentByStylename("ddtroom.roomPlayerItemTipsBG");
            addChild(this._bg);
            this._textFrameArray = new Vector.<FilterFrameText>();
            _local_1 = ComponentFactory.Instance.creatComponentByStylename("ddtroom.roomPlayerItemTips.contentTxt");
            _local_1.visible = false;
            addChild(_local_1);
            this._textFrameArray.push(_local_1);
            _local_2 = ComponentFactory.Instance.creatComponentByStylename("ddtroom.roomPlayerItemTips.contentTxt2");
            _local_2.visible = false;
            addChild(_local_2);
            this._textFrameArray.push(_local_2);
            var _local_3:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("ddtroom.roomPlayerItemTips.contentTxt3");
            _local_3.visible = false;
            addChild(_local_3);
            this._textFrameArray.push(_local_3);
            _local_4 = ComponentFactory.Instance.creatComponentByStylename("ddtroom.roomPlayerItemTips.contentTxt4");
            _local_4.visible = false;
            addChild(_local_4);
            this._textFrameArray.push(_local_4);
            _local_5 = ComponentFactory.Instance.creatComponentByStylename("ddtroom.roomPlayerItemTips.contentTxt5");
            _local_5.visible = false;
            addChild(_local_5);
            this._textFrameArray.push(_local_5);
            this._contentLabel = ComponentFactory.Instance.model.getSet("ddtroom.roomPlayerItemTips.contentLabelTF");
        }

        override public function get tipData():Object
        {
            return (_tipData);
        }

        override public function set tipData(_arg_1:Object):void
        {
            _tipData = _arg_1;
            if (_tipData)
            {
                this.visible = true;
                this.reset();
                this.update();
            }
            else
            {
                this.visible = false;
            };
        }

        private function returnFilterFrameText(_arg_1:String):FilterFrameText
        {
            var _local_4:FilterFrameText;
            var _local_2:FilterFrameText;
            var _local_3:int;
            while (_local_3 < this._textFrameArray.length)
            {
                _local_4 = this._textFrameArray[_local_3];
                if (((_local_4.text == "") || (_local_4.text == _arg_1)))
                {
                    _local_2 = _local_4;
                    break;
                };
                _local_3++;
            };
            return (_local_4);
        }

        private function isVisibleFunction():void
        {
            var _local_2:FilterFrameText;
            var _local_1:int;
            for each (_local_2 in this._textFrameArray)
            {
                if (_local_2.text == "")
                {
                    _local_2.visible = false;
                }
                else
                {
                    _local_1++;
                    _local_2.visible = true;
                };
            };
            if (_local_1 == 0)
            {
                this.visible = false;
            };
        }

        private function reset():void
        {
            var _local_1:FilterFrameText;
            for each (_local_1 in this._textFrameArray)
            {
                _local_1.text = "";
            };
        }

        private function update():void
        {
            var _local_1:PlayerInfo;
            var _local_2:String;
            var _local_3:FilterFrameText;
            var _local_4:String;
            var _local_5:FilterFrameText;
            if ((_tipData is PlayerInfo))
            {
                _local_1 = (_tipData as PlayerInfo);
                if (_local_1.ID == _local_1.ID)
                {
                    if (_local_1.IsMarried)
                    {
                        _local_2 = LanguageMgr.GetTranslation("ddt.room.roomPlayerItemTip.SpouseNameTxt", _local_1.SpouseName);
                        _local_3 = this.returnFilterFrameText(_local_2);
                        if (_local_3)
                        {
                            _local_3.text = _local_2;
                            _local_3.setTextFormat(this._contentLabel, 0, _local_1.SpouseName.length);
                        };
                    };
                }
                else
                {
                    if (_local_1.IsMarried)
                    {
                        _local_4 = LanguageMgr.GetTranslation("ddt.room.roomPlayerItemTip.SpouseNameTxt", _local_1.SpouseName);
                        _local_5 = this.returnFilterFrameText(_local_4);
                        if (_local_5)
                        {
                            _local_5.text = _local_4;
                            _local_5.setTextFormat(this._contentLabel, 0, _local_1.SpouseName.length);
                        };
                    };
                };
            };
            this.isVisibleFunction();
            this.updateBgSize();
        }

        private function updateBgSize():void
        {
            this._bg.width = this.getMaxWidth();
            var _local_1:int;
            var _local_2:int;
            while (_local_2 < this._textFrameArray.length)
            {
                if (this._textFrameArray[_local_2].visible)
                {
                    _local_1++;
                };
                _local_2++;
            };
            this._bg.height = (_local_1 * MIN_HEIGHT);
        }

        private function getMaxWidth():int
        {
            var _local_1:int;
            var _local_2:int;
            while (_local_2 < this._textFrameArray.length)
            {
                if (((this._textFrameArray[_local_2].visible) && (this._textFrameArray[_local_2].width > _local_1)))
                {
                    _local_1 = this._textFrameArray[_local_2].width;
                };
                _local_2++;
            };
            return (_local_1 + 10);
        }

        override public function dispose():void
        {
            this._textFrameArray = null;
            if (this._contentLabel)
            {
                this._contentLabel = null;
            };
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            this._bg = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
            super.dispose();
        }


    }
}//package room.view

