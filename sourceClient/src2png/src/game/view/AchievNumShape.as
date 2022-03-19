// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.AchievNumShape

package game.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import ddt.manager.BitmapManager;
    import __AS3__.vec.Vector;
    import ddt.display.BitmapShape;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class AchievNumShape extends Sprite implements Disposeable 
    {

        private var _bitmapMgr:BitmapManager;
        private var _numShapes:Vector.<BitmapShape> = new Vector.<BitmapShape>();

        public function AchievNumShape()
        {
            visible = (mouseChildren = (mouseEnabled = false));
            this._bitmapMgr = BitmapManager.getBitmapMgr("GameView");
        }

        public function dispose():void
        {
            ObjectUtils.disposeObject(this._bitmapMgr);
            this._bitmapMgr = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function drawNum(_arg_1:int):void
        {
            var _local_2:BitmapShape = this._numShapes.shift();
            while (_local_2 != null)
            {
                ObjectUtils.disposeObject(_local_2);
                _local_2 = this._numShapes.shift();
            };
            var _local_3:String = _arg_1.toString();
            var _local_4:int = _local_3.length;
            var _local_5:int;
            while (_local_5 < _local_4)
            {
                _local_2 = this._bitmapMgr.creatBitmapShape(("asset.game.achiev.num" + _local_3.substr(_local_5, 1)));
                if (_local_5 > 0)
                {
                    _local_2.x = (this._numShapes[(_local_5 - 1)].x + this._numShapes[(_local_5 - 1)].width);
                };
                addChild(_local_2);
                this._numShapes.push(_local_2);
                _local_5++;
            };
            visible = true;
        }


    }
}//package game.view

