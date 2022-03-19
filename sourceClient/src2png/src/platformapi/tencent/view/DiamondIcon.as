// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//platformapi.tencent.view.DiamondIcon

package platformapi.tencent.view
{
    import flash.display.Sprite;
    import platformapi.tencent.interfaces.IDiamondIcon;
    import platformapi.tencent.DiamondManager;
    import flash.events.Event;
    import flash.display.DisplayObject;
    import platformapi.tencent.DiamondType;
    import com.pickgliss.utils.ObjectUtils;

    public class DiamondIcon extends Sprite implements IDiamondIcon 
    {

        private var _type:int;
        private var _icon:IDiamondIcon;
        private var _level:int;
        private var _isDisposed:Boolean;
        private var _width:int;
        private var _height:int;

        public function DiamondIcon(_arg_1:int, _arg_2:int=30, _arg_3:int=26)
        {
            this._type = _arg_1;
            this._width = _arg_2;
            this._height = _arg_3;
            DiamondManager.instance.addEventListener(Event.COMPLETE, this.__init);
            DiamondManager.instance.loadUIModule();
        }

        private function __init(_arg_1:Event=null):void
        {
            var _local_2:DisplayObject;
            DiamondManager.instance.removeEventListener(Event.COMPLETE, this.__init);
            if (this._isDisposed)
            {
                return;
            };
            if (this._type == 0)
            {
                switch (DiamondManager.instance.model.pfdata.pfType)
                {
                    case DiamondType.YELLOW_DIAMOND:
                        this._icon = new YellowDiamondIcon();
                        break;
                    case DiamondType.BLUE_DIAMOND:
                        this._icon = new BlueDiamondIcon();
                        break;
                    case DiamondType.MEMBER_DIAMOND:
                        this._icon = new MemberDiamondIcon();
                };
            }
            else
            {
                this._icon = new BunIcon();
            };
            if (this._icon)
            {
                _local_2 = (this._icon as DisplayObject);
                _local_2.x = ((this._width - _local_2.width) / 2);
                _local_2.y = ((this._height - _local_2.height) / 2);
                addChild(DisplayObject(this._icon));
            };
            this.level = this._level;
        }

        public function set level(_arg_1:int):void
        {
            this._level = _arg_1;
            if (this._icon)
            {
                this._icon.level = this._level;
            };
        }

        public function get level():int
        {
            return (this._level);
        }

        public function dispose():void
        {
            DiamondManager.instance.removeEventListener(Event.COMPLETE, this.__init);
            this._isDisposed = true;
            ObjectUtils.disposeObject(this._icon);
            this._icon = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package platformapi.tencent.view

