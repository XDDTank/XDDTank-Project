// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.experience.ExpTotalNums

package game.view.experience
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.MovieClip;
    import flash.display.Bitmap;
    import __AS3__.vec.Vector;
    import flash.display.BitmapData;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import flash.events.Event;
    import __AS3__.vec.*;

    public class ExpTotalNums extends Sprite implements Disposeable 
    {

        public static const EXPERIENCE:uint = 0;
        public static const EXPLOIT:uint = 1;

        public var maxValue:int;
        private var _value:int;
        private var _type:int;
        private var _bg:MovieClip;
        private var _operator:Bitmap;
        private var _bitmaps:Vector.<Bitmap>;
        private var _bitmapDatas:Vector.<BitmapData>;

        public function ExpTotalNums(_arg_1:int)
        {
            this._type = _arg_1;
            this.init();
        }

        private function init():void
        {
            var _local_1:String;
            this._operator = new Bitmap();
            this._bitmaps = new Vector.<Bitmap>(5);
            this._bitmapDatas = new Vector.<BitmapData>();
            if (this._type == EXPERIENCE)
            {
                _local_1 = "asset.experience.TotalExpNum_";
                this._bg = ComponentFactory.Instance.creat("asset.experience.TotalExpTxtLight");
            }
            else
            {
                _local_1 = "asset.experience.TotalExploitNum_";
                this._bg = ComponentFactory.Instance.creat("asset.experience.TotalExploitTxtLight");
            };
            PositionUtils.setPos(this._bg, "experience.TotalTextLightPos");
            addChildAt(this._bg, 0);
            var _local_2:int;
            while (_local_2 < 10)
            {
                this._bitmapDatas.push(ComponentFactory.Instance.creatBitmapData((_local_1 + String(_local_2))));
                _local_2++;
            };
            this._bitmapDatas.push(ComponentFactory.Instance.creatBitmapData((_local_1 + "+")));
            this._bitmapDatas.push(ComponentFactory.Instance.creatBitmapData((_local_1 + "-")));
        }

        public function playLight():void
        {
            this._bg.gotoAndPlay(2);
        }

        public function setValue(_arg_1:int):void
        {
            var _local_2:int;
            var _local_4:Array;
            this._value = _arg_1;
            _local_2 = 0;
            var _local_3:int = 20;
            if (this._value >= 0)
            {
                this._operator.bitmapData = this._bitmapDatas[10];
            }
            else
            {
                this._operator.bitmapData = this._bitmapDatas[11];
            };
            addChild(this._operator);
            _local_2 = (_local_2 + _local_3);
            this._value = Math.abs(this._value);
            _local_4 = this._value.toString().split("");
            var _local_5:int;
            while (_local_5 < _local_4.length)
            {
                if (this._bitmaps[_local_5] == null)
                {
                    this._bitmaps[_local_5] = new Bitmap();
                };
                this._bitmaps[_local_5].bitmapData = this._bitmapDatas[int(_local_4[_local_5])];
                this._bitmaps[_local_5].x = _local_2;
                _local_2 = (_local_2 + _local_3);
                addChild(this._bitmaps[_local_5]);
                _local_5++;
            };
            dispatchEvent(new Event(Event.COMPLETE));
        }

        public function dispose():void
        {
            if (this._bg)
            {
                if (this._bg.parent)
                {
                    this._bg.parent.removeChild(this._bg);
                };
                this._bg = null;
            };
            if (this._operator)
            {
                if (this._operator.parent)
                {
                    this._operator.parent.removeChild(this._operator);
                };
                this._operator.bitmapData.dispose();
                this._operator = null;
            };
            this._bitmapDatas = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package game.view.experience

