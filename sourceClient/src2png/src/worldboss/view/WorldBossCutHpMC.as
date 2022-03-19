// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//worldboss.view.WorldBossCutHpMC

package worldboss.view
{
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.Event;
    import flash.utils.setTimeout;

    public class WorldBossCutHpMC extends Sprite 
    {

        public static const _space:int = 19;

        private var _num:Number;
        private var _type:int;
        private var _numBitmapArr:Array;

        public function WorldBossCutHpMC(_arg_1:Number)
        {
            this._num = Math.abs(_arg_1);
            this.init();
        }

        private function init():void
        {
            var _local_4:Bitmap;
            this._numBitmapArr = new Array();
            var _local_1:String = this._num.toString();
            var _local_2:Bitmap = ComponentFactory.Instance.creatBitmap("worldboss.cutHP.valuNum10");
            this._numBitmapArr.push(_local_2);
            _local_2.alpha = 0;
            _local_2.scaleX = 0.5;
            addChild(_local_2);
            var _local_3:int;
            while (_local_3 < _local_1.length)
            {
                _local_4 = ComponentFactory.Instance.creatBitmap(("worldboss.cutHP.valuNum" + _local_1.charAt(_local_3)));
                _local_4.x = (_space * (_local_3 + 1));
                _local_4.alpha = 0;
                _local_4.scaleX = 0.5;
                this._numBitmapArr.push(_local_4);
                addChild(_local_4);
                _local_3++;
            };
            addEventListener(Event.ENTER_FRAME, this.actionOne);
        }

        private function actionOne(_arg_1:Event):void
        {
            var _local_2:int;
            while (_local_2 < this._numBitmapArr.length)
            {
                if (this._numBitmapArr[_local_2].alpha >= 1)
                {
                    removeEventListener(Event.ENTER_FRAME, this.actionOne);
                    setTimeout(this.actionTwo, 500);
                    return;
                };
                this._numBitmapArr[_local_2].alpha = (this._numBitmapArr[_local_2].alpha + 0.2);
                this._numBitmapArr[_local_2].scaleX = (this._numBitmapArr[_local_2].scaleX + 0.1);
                this._numBitmapArr[_local_2].x = (this._numBitmapArr[_local_2].x + 2);
                this._numBitmapArr[_local_2].y = (this._numBitmapArr[_local_2].y - 7);
                _local_2++;
            };
        }

        private function actionTwo():void
        {
            addEventListener(Event.ENTER_FRAME, this.actionTwoStart);
        }

        private function actionTwoStart(_arg_1:Event):void
        {
            var _local_2:int;
            while (_local_2 < this._numBitmapArr.length)
            {
                if (this._numBitmapArr[_local_2].alpha <= 0)
                {
                    this.dispose();
                    return;
                };
                this._numBitmapArr[_local_2].alpha = (this._numBitmapArr[_local_2].alpha - 0.2);
                this._numBitmapArr[_local_2].y = (this._numBitmapArr[_local_2].y - 7);
                _local_2++;
            };
        }

        private function dispose():void
        {
            var _local_1:int;
            removeEventListener(Event.ENTER_FRAME, this.actionTwoStart);
            if (this._numBitmapArr)
            {
                _local_1 = 0;
                while (_local_1 < this._numBitmapArr.length)
                {
                    removeChild(this._numBitmapArr[_local_1]);
                    this._numBitmapArr[_local_1] = null;
                    this._numBitmapArr.shift();
                };
                this._numBitmapArr = null;
            };
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package worldboss.view

