// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.experience.ExpResultSeal

package game.view.experience
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import __AS3__.vec.Vector;
    import flash.display.DisplayObject;
    import flash.display.Bitmap;
    import flash.display.MovieClip;
    import ddt.utils.PositionUtils;
    import com.pickgliss.ui.ComponentFactory;
    import flash.geom.Point;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class ExpResultSeal extends Sprite implements Disposeable 
    {

        public static const WIN:String = "win";
        public static const LOSE:String = "lose";

        private var _luckyShapes:Vector.<DisplayObject> = new Vector.<DisplayObject>();
        private var _luckyExp:Boolean;
        private var _luckyOffer:Boolean;
        private var _bitmap:Bitmap;
        private var _starMc:MovieClip;
        private var _effectMc:MovieClip;
        private var _result:String;

        public function ExpResultSeal(_arg_1:String="lose", _arg_2:Boolean=false, _arg_3:Boolean=false)
        {
            this._result = _arg_1;
            this._luckyExp = _arg_2;
            this._luckyOffer = _arg_3;
            this.init();
        }

        protected function init():void
        {
            PositionUtils.setPos(this, "experience.ResultSealPos");
            if (this._result == WIN)
            {
                this._bitmap = ComponentFactory.Instance.creatBitmap("asset.experience.rightViewWin");
                this._starMc = ComponentFactory.Instance.creat("experience.WinStar");
                this._effectMc = ComponentFactory.Instance.creat("experience.WinEffectLight");
                addChild(this._starMc);
                addChildAt(this._effectMc, 0);
            }
            else
            {
                this._bitmap = ComponentFactory.Instance.creatBitmap("asset.experience.rightViewLose");
            };
            addChild(this._bitmap);
            if (this._luckyExp)
            {
                this._luckyShapes.push(ComponentFactory.Instance.creat("asset.expView.LuckyExp"));
            };
            if (this._luckyOffer)
            {
                this._luckyShapes.push(ComponentFactory.Instance.creat("asset.expView.LuckyOffer"));
            };
            var _local_1:Point = ComponentFactory.Instance.creat("experience.ResultSealLuckyLeft");
            var _local_2:int;
            while (_local_2 < this._luckyShapes.length)
            {
                this._luckyShapes[_local_2].x = (_local_1.x + (_local_2 * 124));
                addChild(this._luckyShapes[_local_2]);
                _local_2++;
            };
        }

        public function dispose():void
        {
            if (((this._starMc) && (this._starMc.parent)))
            {
                this._starMc.parent.removeChild(this._starMc);
            };
            if (((this._effectMc) && (this._effectMc.parent)))
            {
                this._effectMc.parent.removeChild(this._effectMc);
            };
            this._starMc = null;
            this._effectMc = null;
            if (this._bitmap)
            {
                ObjectUtils.disposeObject(this._bitmap);
                this._bitmap = null;
            };
            if (parent)
            {
                parent.removeChild(this);
            };
            var _local_1:DisplayObject = this._luckyShapes.shift();
            while (_local_1 != null)
            {
                ObjectUtils.disposeObject(_local_1);
                _local_1 = this._luckyShapes.shift();
            };
        }


    }
}//package game.view.experience

