// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.experience.ExpFightExpItem

package game.view.experience
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import __AS3__.vec.Vector;
    import ddt.utils.PositionUtils;
    import com.pickgliss.ui.ComponentFactory;
    import flash.geom.Point;
    import game.GameManager;
    import room.model.RoomInfo;
    import flash.events.Event;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class ExpFightExpItem extends Sprite implements Disposeable 
    {

        protected var _bg:Bitmap;
        protected var _titleBitmap:Bitmap;
        protected var _itemType:String;
        protected var _typeTxts:Vector.<ExpTypeTxt>;
        protected var _numTxt:ExpCountingTxt;
        protected var _step:int;
        protected var _value:Number;
        protected var _valueArr:Array;

        public function ExpFightExpItem(_arg_1:Array)
        {
            this._valueArr = _arg_1;
            this.init();
        }

        protected function init():void
        {
            this._itemType = ExpTypeTxt.FIGHTING_EXP;
            PositionUtils.setPos(this, "experience.FightingExpItemPos");
            this._bg = ComponentFactory.Instance.creatBitmap("asset.experience.fightExpItemBg");
            this._titleBitmap = ComponentFactory.Instance.creatBitmap("asset.experience.fightExpItemTitle");
        }

        public function createView():void
        {
            var _local_2:Point;
            var _local_1:Point = ComponentFactory.Instance.creatCustomObject("experience.txtStartPos");
            _local_2 = ComponentFactory.Instance.creatCustomObject("experience.txtOffset");
            PositionUtils.setPos(this._bg, "experience.ItemBgPos");
            this._typeTxts = new Vector.<ExpTypeTxt>();
            addChild(this._bg);
            addChild(this._titleBitmap);
            this._step = 0;
            var _local_3:int;
            var _local_4:int;
            var _local_5:int = ((this._itemType == ExpTypeTxt.FIGHTING_EXP) ? 1 : ((this._itemType == ExpTypeTxt.ATTATCH_EXP) ? 9 : 6));
            var _local_6:int;
            while (_local_6 < _local_5)
            {
                if (!((_local_6 == 4) || (_local_6 == 5)))
                {
                    if (((((this._itemType == ExpTypeTxt.ATTATCH_EXP) && ((_local_6 == 1) || (_local_6 == 7))) && (!(GameManager.Instance.Current.roomType == RoomInfo.MATCH_ROOM))) && (!(GameManager.Instance.Current.roomType == RoomInfo.CHALLENGE_ROOM))))
                    {
                        _local_4++;
                    }
                    else
                    {
                        this._typeTxts.push(new ExpTypeTxt(this._itemType, _local_6, this._valueArr[_local_6]));
                        if ((((_local_3 % 2) == 0) && (!(_local_3 == 8))))
                        {
                            this._typeTxts[_local_3].y = (_local_1.y = (_local_1.y + _local_2.y));
                            this._typeTxts[_local_3].x = _local_1.x;
                        }
                        else
                        {
                            this._typeTxts[_local_3].y = _local_1.y;
                            this._typeTxts[_local_3].x = (_local_1.x + _local_2.x);
                        };
                        this._typeTxts[_local_3].addEventListener(Event.CHANGE, this.__updateText);
                        addChild(this._typeTxts[_local_3]);
                        _local_3++;
                    };
                };
                _local_6++;
            };
            this.createNumTxt();
        }

        protected function createNumTxt():void
        {
            this._numTxt = new ExpCountingTxt("experience.expCountTxt", "experience.expTxtFilter_1,experience.expTxtFilter_2");
            this._numTxt.addEventListener(Event.CHANGE, this.__onTextChange);
            addChild(this._numTxt);
        }

        private function __updateText(_arg_1:Event=null):void
        {
            this._numTxt.updateNum(_arg_1.currentTarget.value);
        }

        protected function __onTextChange(_arg_1:Event):void
        {
            this._value = _arg_1.currentTarget.targetValue;
            dispatchEvent(new Event(Event.CHANGE));
        }

        public function get targetValue():Number
        {
            return (this._numTxt.targetValue);
        }

        public function dispose():void
        {
            if (this._numTxt)
            {
                this._numTxt.removeEventListener(Event.CHANGE, this.__onTextChange);
                this._numTxt.dispose();
                this._numTxt = null;
            };
            var _local_1:int = this._typeTxts.length;
            var _local_2:int;
            while (_local_2 < _local_1)
            {
                this._typeTxts[_local_2].removeEventListener(Event.CHANGE, this.__updateText);
                this._typeTxts[_local_2].dispose();
                this._typeTxts[_local_2] = null;
                _local_2++;
            };
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
                this._bg = null;
            };
            if (this._titleBitmap)
            {
                ObjectUtils.disposeObject(this._titleBitmap);
                this._titleBitmap = null;
            };
            this._valueArr = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package game.view.experience

