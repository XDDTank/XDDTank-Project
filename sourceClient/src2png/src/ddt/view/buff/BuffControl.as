// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.buff.BuffControl

package ddt.view.buff
{
    import flash.display.Sprite;
    import road7th.data.DictionaryData;
    import com.pickgliss.ui.controls.container.HBox;
    import ddt.data.BuffInfo;
    import ddt.manager.PlayerManager;
    import road7th.data.DictionaryEvent;
    import ddt.view.buff.buffButton.BuffButton;
    import ddt.view.buff.buffButton.PayBuffButton;
    import com.pickgliss.utils.ObjectUtils;

    public class BuffControl extends Sprite 
    {

        private var _buffData:DictionaryData;
        private var _buffList:HBox;
        private var _buffBtnArr:Array;
        private var _str:String;
        private var _spacing:int;

        public function BuffControl(_arg_1:String="", _arg_2:int=8)
        {
            this._spacing = _arg_2;
            this._str = _arg_1;
            this.init();
            this.initEvents();
        }

        public static function isPayBuff(_arg_1:BuffInfo):Boolean
        {
            switch (_arg_1.Type)
            {
                case BuffInfo.Caddy_Good:
                case BuffInfo.Save_Life:
                case BuffInfo.Agility:
                case BuffInfo.ReHealth:
                case BuffInfo.Train_Good:
                case BuffInfo.Level_Try:
                case BuffInfo.Card_Get:
                    return (true);
                default:
                    return (false);
            };
        }


        private function init():void
        {
            this._buffData = PlayerManager.Instance.Self.buffInfo;
            this._buffList = new HBox();
            this._buffList.spacing = this._spacing;
            addChild(this._buffList);
            this.initBuffButtons();
        }

        private function initEvents():void
        {
            this._buffData.addEventListener(DictionaryEvent.ADD, this.__addBuff);
            this._buffData.addEventListener(DictionaryEvent.REMOVE, this.__removeBuff);
            this._buffData.addEventListener(DictionaryEvent.UPDATE, this.__addBuff);
        }

        private function removeEvents():void
        {
            if (this._buffData)
            {
                this._buffData.removeEventListener(DictionaryEvent.ADD, this.__addBuff);
                this._buffData.removeEventListener(DictionaryEvent.REMOVE, this.__removeBuff);
                this._buffData.removeEventListener(DictionaryEvent.UPDATE, this.__addBuff);
            };
        }

        private function initBuffButtons():void
        {
            var _local_2:BuffButton;
            this._buffBtnArr = [];
            var _local_1:int = 1;
            while (_local_1 <= 4)
            {
                if (_local_1 < 4)
                {
                    _local_2 = BuffButton.createBuffButton(_local_1);
                    if (this._str == "")
                    {
                    };
                }
                else
                {
                    _local_2 = BuffButton.createBuffButton(_local_1, this._str);
                    _local_2.CanClick = false;
                };
                this._buffBtnArr.push(_local_2);
                _local_1++;
            };
            this.setInfo(this._buffData);
        }

        public function setInfo(_arg_1:DictionaryData):void
        {
            var _local_2:String;
            for (_local_2 in _arg_1)
            {
                if (_arg_1[_local_2] != null)
                {
                    switch (_arg_1[_local_2].Type)
                    {
                        case BuffInfo.DOUBEL_EXP:
                            this._buffBtnArr[0].info = _arg_1[_local_2];
                            break;
                        case BuffInfo.DOUBLE_GESTE:
                            this._buffBtnArr[1].info = _arg_1[_local_2];
                            break;
                        case BuffInfo.PREVENT_KICK:
                            this._buffBtnArr[2].info = _arg_1[_local_2];
                            break;
                        case BuffInfo.Caddy_Good:
                        case BuffInfo.Save_Life:
                        case BuffInfo.Agility:
                        case BuffInfo.ReHealth:
                        case BuffInfo.Train_Good:
                        case BuffInfo.Level_Try:
                        case BuffInfo.Card_Get:
                            PayBuffButton(this._buffBtnArr[3]).addBuff(_arg_1[_local_2]);
                            break;
                    };
                };
            };
        }

        private function __addBuff(_arg_1:DictionaryEvent):void
        {
            var _local_2:BuffInfo = (_arg_1.data as BuffInfo);
            switch (_local_2.Type)
            {
                case BuffInfo.DOUBEL_EXP:
                    this.setBuffButtonInfo(0, _local_2);
                    return;
                case BuffInfo.DOUBLE_GESTE:
                    this.setBuffButtonInfo(1, _local_2);
                    return;
                case BuffInfo.PREVENT_KICK:
                    this.setBuffButtonInfo(2, _local_2);
                    return;
                case BuffInfo.Caddy_Good:
                case BuffInfo.Save_Life:
                case BuffInfo.Agility:
                case BuffInfo.ReHealth:
                case BuffInfo.Train_Good:
                case BuffInfo.Level_Try:
                case BuffInfo.Card_Get:
                    PayBuffButton(this._buffBtnArr[3]).addBuff(_local_2);
                    return;
            };
        }

        private function setBuffButtonInfo(_arg_1:int, _arg_2:BuffInfo):void
        {
            if (_arg_2.IsExist)
            {
                this._buffBtnArr[_arg_1].info = _arg_2;
            }
            else
            {
                this._buffBtnArr[_arg_1].isExist = false;
            };
        }

        private function __removeBuff(_arg_1:DictionaryEvent):void
        {
            switch ((_arg_1.data as BuffInfo).Type)
            {
                case BuffInfo.DOUBEL_EXP:
                    this._buffBtnArr[0].info = new BuffInfo(BuffInfo.DOUBEL_EXP);
                    return;
                case BuffInfo.DOUBLE_GESTE:
                    this._buffBtnArr[1].info = new BuffInfo(BuffInfo.DOUBLE_GESTE);
                    return;
                case BuffInfo.PREVENT_KICK:
                    this._buffBtnArr[2].info = new BuffInfo(BuffInfo.PREVENT_KICK);
                    return;
            };
        }

        private function __updateBuff(_arg_1:DictionaryEvent):void
        {
        }

        public function set CanClick(_arg_1:Boolean):void
        {
            var _local_2:BuffButton;
            for each (_local_2 in this._buffBtnArr)
            {
                _local_2.CanClick = _arg_1;
            };
        }

        public function dispose():void
        {
            this.removeEvents();
            if (this._buffList)
            {
                ObjectUtils.disposeObject(this._buffList);
                this._buffList = null;
            };
            this._buffData = null;
            this._buffBtnArr = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package ddt.view.buff

