// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.tip.BaseTip

package com.pickgliss.ui.tip
{
    import com.pickgliss.ui.core.Component;
    import com.pickgliss.ui.image.Image;
    import com.pickgliss.ui.vo.DirectionPos;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.ComponentFactory;

    public class BaseTip extends Component implements ITip 
    {

        public static const P_tipbackgound:String = "tipbackgound";

        protected var _tipbackgound:Image;
        protected var _tipbackgoundstyle:String;
        protected var _currentDirection:DirectionPos;

        public function BaseTip()
        {
            mouseChildren = false;
            mouseEnabled = false;
        }

        override public function dispose():void
        {
            if (this._tipbackgound)
            {
                ObjectUtils.disposeObject(this._tipbackgound);
            };
            this._tipbackgound = null;
            super.dispose();
        }

        public function set tipbackgound(_arg_1:Image):void
        {
            if (this._tipbackgound == _arg_1)
            {
                return;
            };
            ObjectUtils.disposeObject(this._tipbackgound);
            this._tipbackgound = _arg_1;
            onPropertiesChanged(P_tipbackgound);
        }

        public function set tipbackgoundstyle(_arg_1:String):void
        {
            if (this._tipbackgoundstyle == _arg_1)
            {
                return;
            };
            this._tipbackgoundstyle = _arg_1;
            this.tipbackgound = ComponentFactory.Instance.creat(this._tipbackgoundstyle);
        }

        override protected function addChildren():void
        {
            super.addChildren();
            if (this._tipbackgound)
            {
                addChild(this._tipbackgound);
            };
        }

        public function get currentDirectionPos():DirectionPos
        {
            return (this._currentDirection);
        }

        public function set currentDirectionPos(_arg_1:DirectionPos):void
        {
            this._currentDirection = _arg_1;
        }


    }
}//package com.pickgliss.ui.tip

