// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.refining.RefiningProgress

package store.view.refining
{
    import store.view.strength.StoreStrengthProgress;
    import store.StoreController;
    import flash.utils.Dictionary;
    import flash.events.Event;
    import ddt.data.goods.InventoryItemInfo;

    public class RefiningProgress extends StoreStrengthProgress 
    {

        private var _infoID:int;


        public function get infoID():int
        {
            return (this._infoID);
        }

        override public function initProgress(_arg_1:InventoryItemInfo):void
        {
            var _local_2:Number;
            var _local_3:int;
            this._infoID = _arg_1.ItemID;
            _currentFrame = 0;
            _strengthenExp = _arg_1.StrengthenExp;
            _strengthenLevel = _arg_1.StrengthenLevel;
            if (StoreController.instance.Model.getRefiningConfigByLevel((_strengthenLevel + 1)))
            {
                _max = StoreController.instance.Model.getRefiningConfigByLevel((_strengthenLevel + 1)).Exp;
            }
            else
            {
                _max = 0;
            };
            if (((_max > 0) && (_strengthenExp < _max)))
            {
                _local_2 = (_strengthenExp / _max);
                _local_3 = Math.floor((_local_2 * _total));
                if (((_local_3 < 1) && (_local_2 > 0)))
                {
                    _local_3 = 1;
                };
                _currentFrame = _local_3;
            };
            setMask(_currentFrame);
            this.setExpPercent(_arg_1);
            _taskFrames = new Dictionary();
            if (this.hasEventListener(Event.ENTER_FRAME))
            {
                this.removeEventListener(Event.ENTER_FRAME, __startFrame);
            };
            setStarVisible(false);
        }

        override public function setProgress(_arg_1:InventoryItemInfo):void
        {
            this._infoID = _arg_1.ItemID;
            if (_strengthenLevel != _arg_1.StrengthenLevel)
            {
                _taskFrames[0] = _total;
                _strengthenLevel = _arg_1.StrengthenLevel;
            };
            _strengthenExp = _arg_1.StrengthenExp;
            if (StoreController.instance.Model.getRefiningConfigByLevel((_strengthenLevel + 1)))
            {
                _max = StoreController.instance.Model.getRefiningConfigByLevel((_strengthenLevel + 1)).Exp;
            }
            else
            {
                _max = 0;
            };
            var _local_2:Number = (_strengthenExp / _max);
            var _local_3:int = Math.floor((_local_2 * _total));
            if (((_local_3 < 1) && (_local_2 > 0)))
            {
                _local_3 = 1;
            };
            if (_currentFrame == _local_3)
            {
                if (((_taskFrames[0]) && (!(int(_taskFrames[0]) == 0))))
                {
                    setStarVisible(true);
                    _taskFrames[1] = _local_3;
                    startProgress();
                };
            }
            else
            {
                setStarVisible(true);
                _taskFrames[1] = _local_3;
                startProgress();
            };
            this.setExpPercent(_arg_1);
        }

        override public function setExpPercent(_arg_1:InventoryItemInfo=null):void
        {
            var _local_2:Number;
            this._infoID = _arg_1.ItemID;
            if (_strengthenExp == 0)
            {
                _progressLabel.text = "0%";
            }
            else
            {
                _local_2 = (Math.floor(((_strengthenExp / _max) * 10000)) / 100);
                if (((isNaN(_local_2)) || (_max == 0)))
                {
                    _local_2 = 0;
                };
                _progressLabel.text = (_local_2 + "%");
            };
            if (((_arg_1) && (!(StoreController.instance.Model.getRefiningConfigByLevel(_strengthenLevel)))))
            {
                tipData = "0/0";
            }
            else
            {
                if (((isNaN(_strengthenExp)) || (_max == 0)))
                {
                    _strengthenExp = 0;
                };
                if (isNaN(_max))
                {
                    _max = 0;
                };
                tipData = ((_strengthenExp + "/") + _max);
            };
        }

        override public function resetProgress():void
        {
            this._infoID = 0;
            super.resetProgress();
        }


    }
}//package store.view.refining

