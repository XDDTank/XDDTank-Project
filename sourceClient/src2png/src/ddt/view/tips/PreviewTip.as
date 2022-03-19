// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.tips.PreviewTip

package ddt.view.tips
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.tip.ITransformableTip;
    import flash.display.DisplayObject;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.vo.DirectionPos;

    public class PreviewTip extends Sprite implements Disposeable, ITransformableTip 
    {

        private var _tipData:Object;


        public function get tipWidth():int
        {
            return (width);
        }

        public function set tipWidth(_arg_1:int):void
        {
        }

        public function get tipHeight():int
        {
            return (height);
        }

        public function set tipHeight(_arg_1:int):void
        {
        }

        public function get tipData():Object
        {
            return (this._tipData);
        }

        public function set tipData(_arg_1:Object):void
        {
            if (((!(_arg_1)) || ((_arg_1 is DisplayObject) == false)))
            {
                return;
            };
            if (_arg_1 == this._tipData)
            {
                return;
            };
            this._tipData = _arg_1;
            ObjectUtils.disposeAllChildren(this);
            addChild((this._tipData as DisplayObject));
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }

        public function dispose():void
        {
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function get currentDirectionPos():DirectionPos
        {
            return (null);
        }

        public function set currentDirectionPos(_arg_1:DirectionPos):void
        {
        }


    }
}//package ddt.view.tips

